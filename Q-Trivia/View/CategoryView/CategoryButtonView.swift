//
//  CategoryButtonView.swift
//  Q-Trivia
//
//  Created by Christopher Perault on 1/28/23.
//

import SwiftUI

struct CategoryButtonView: View {
    var category: CategoryModel
    var buttonAction: () -> Void
    
    var body: some View {
        Button(action: buttonAction, label: {
            HStack {
                Text(category.categoryName)
                Spacer()
                Image(category.categoryIcon)
            }
        })
        .modifier(CategoryButtonViewModifier())
    }
}
