//
//  CategoryView.swift
//  Q-Trivia
//
//  Created by Christopher Perault on 1/28/23.
//

import SwiftUI

struct CategoryView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var networkEnforcement: NetworkEnforcement
    
    // FETCH REQUESTS
    @FetchRequest(
        entity: Category.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \Category.id,
                ascending: true)
        ]
    ) private var allCategories: FetchedResults<Category>
    
    @State private var categories: [CategoryModel] = [CategoryModel]()
    @State private var selectedCategory: CategoryModel? = nil
    @State private var isPresentingConfirmation: Bool = false
    @State private var isReadyToStartGame: Bool = false
    @State private var isNotConnectedToNetwork: Bool = false
    
    @AppStorage("selectedCategoryID") private var selectedCategoryID = 0
    @AppStorage("selectedCategoryName") private var selectedCategoryName = ""
    
    private var randomCategory: (Int, String) {
        let category = categories[Int.random(in: 0..<categories.count)]
        return (Int(category.id), category.name)
    }
    
    private var confirmedCategoryName: String {
        if let category = selectedCategory?.categoryName {
            return category
        } else {
            return ""
        }
    }
    
    private func fetchCategories() {
        if allCategories.isEmpty {
            URLSession.shared.request(url: Constants.allCategoriesURL, expectedEncodingType: CategoryAPIResponse.self) { (result: Result<CategoryAPIResponse, Error>) in
                switch result {
                case .success(let response):
                    categories = response.trivia_categories
                    for category in categories {
                        let newCategory = Category(context: managedObjectContext)
                        newCategory.id = Int16(category.id)
                        newCategory.name = category.name
                        
                        do {
                            try managedObjectContext.update()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func updateCategorySelection(category: CategoryModel) -> Void {
        selectedCategory = category
        selectedCategoryID = category.id
        selectedCategoryName = category.name
        
        isPresentingConfirmation = true
    }

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            List(categories) { category in
                CategoryButtonView(category: category, buttonAction: {
                    updateCategorySelection(category: category)
                })
            }
            .modifier(CategoryListBackgroundModifier())
            .alert("Your trivia category is \(confirmedCategoryName). \nReady to play?", isPresented: $isPresentingConfirmation, actions: {
                Button("Yes, I'm ready!") {
                    if !networkEnforcement.isConnected {
                        isNotConnectedToNetwork = true
                    } else {
                        isReadyToStartGame = true
                    }
                }
                Button("Cancel", role: .cancel) {}
            })
        }
        .navigationDestination(isPresented: $isReadyToStartGame) {
            QuestionView()
        }
        .navigationBarTitle("Categories", displayMode: .inline)
        .onAppear {
            if !networkEnforcement.isConnected {
                isNotConnectedToNetwork = true
            } else {
                if categories.count <= 0 {
                    if allCategories.count <= 0 {
                        fetchCategories()
                    } else {
                        for category in allCategories {
                            categories.append(CategoryModel(id: Int(category.id), name: category.name ?? "N/A"))
                        }
                    }
                }
            }
        }
        .toolbar {
            RandomCategoryButtonView(buttonAction: {
                if categories.count > 0 {
                    let randomCategoryInfo: (Int, String) = randomCategory
                    updateCategorySelection(category: CategoryModel(id: randomCategoryInfo.0, name: randomCategoryInfo.1))
                }
            }, buttonIcon: "dice")
        }
        .alert("Uh oh, it looks like you're not connected to the internet. Please try again when you're reconnected.", isPresented: $isNotConnectedToNetwork, actions: {
            Button("Got it", role: .cancel) {
                presentationMode.wrappedValue.dismiss()
            }
        })
    }
}
