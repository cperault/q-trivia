//
//  SettingsView.swift
//  Q-Trivia
//
//  Created by Christopher Perault on 1/28/23.
//

import SwiftUI

struct SettingsView: View {
    // FETCH REQUESTS
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.id, ascending: true)]) var currentCategories: FetchedResults<Category>
    @FetchRequest(entity: FinishedGame.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FinishedGame.id, ascending: true)]) var currentFinishedGames: FetchedResults<FinishedGame>
    @FetchRequest(entity: Game.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Game.id, ascending: true)]) var currentGames: FetchedResults<Game>
    @FetchRequest(entity: Player.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Player.id, ascending: true)]) var currentPlayers: FetchedResults<Player>
    @FetchRequest(entity: GameQuestion.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \GameQuestion.id, ascending: true)]) var currentGameQuestions: FetchedResults<GameQuestion>
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var gameValues: GameValues
    @State private var isClearingAllData: Bool = false
    @State private var playerName: String = ""
    
    @AppStorage("displayName") private var displayName = "SOLO PLAYER"
    @AppStorage("sessionToken") private var sessionToken = ""
    @AppStorage("sessionTokenStatus") private var sessionTokenStatus: SessionTokenStatus = .Empty
    
    private func clearAllData() {
        if currentCategories.count > 0 {
            for category in currentCategories {
                managedObjectContext.delete(category)
            }
            
            saveData()
        }
        
        if currentGameQuestions.count > 0 {
            for gameQuestion in currentGameQuestions {
                managedObjectContext.delete(gameQuestion)
            }
            
            saveData()
        }
        
        if currentFinishedGames.count > 0 {
            for finishedGame in currentFinishedGames {
                managedObjectContext.delete(finishedGame)
            }
            
            saveData()
        }
        
        if currentGames.count > 0 {
            for game in currentGames {
                managedObjectContext.delete(game)
            }
            
            saveData()
        }
        
        if currentPlayers.count > 0 {
            for player in currentPlayers {
                managedObjectContext.delete(player)
            }
            
            saveData()
        }
        
        displayName = "SOLO PLAYER"
        sessionToken = ""
        sessionTokenStatus = .Empty
    }
    
    private func saveData() {
        do {
            try managedObjectContext.update()
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    private var appHasSavedData: Bool {
        if currentCategories.count > 0 {
            return true
        } else if currentGameQuestions.count > 0 {
            return true
        } else if currentFinishedGames.count > 0 {
            return true
        } else if currentGames.count > 0 {
            return true
        } else if currentPlayers.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Form {
                // QUESTION SETTINGS
                Section(header: Text("Question Settings")) {
                    Stepper(value: $gameValues.questionCount, in: 1...gameValues.maxQuestionCount) {
                        Text("Number of Questions: \(gameValues.questionCount)")
                    }
                }
                
                // APP SETTINGS
                Section(header: Text("App Settings")) {
                    VStack(alignment: .center, spacing: 20) {
                        HStack(alignment: .center, spacing: 20) {
                            Text("Display Name:")
                            Spacer()
                            TextField(displayName.uppercased(), text: $playerName)
                                .modifier(MultiplayerViewTextFieldModifier())
                                .frame(width: 150)
                                .onSubmit {
                                    if playerName.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                                        displayName = playerName.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
                                        playerName = displayName
                                    } else {
                                        playerName = "SOLO PLAYER"
                                        displayName = playerName
                                    }
                                }
                        }
                    }
                    Button("Delete All Data", role: .destructive, action: {
                        isClearingAllData = true
                    })
                    .disabled(!appHasSavedData)
                }
            }
        }
        .navigationBarTitle("Q-Trivia Settings", displayMode: .inline)
        .alert("This will remove all stored gameplay data. This cannot be undone. Are you sure?", isPresented: $isClearingAllData, actions: {
            Button("Delete All Data") {
                clearAllData()
            }
            Button("Cancel", role: .cancel) {}
        })
    }
}
