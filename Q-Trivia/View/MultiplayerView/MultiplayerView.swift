//
//  MultiplayerView.swift
//  Q-Trivia
//
//  Created by Christopher Perault on 1/28/23.
//

import SwiftUI

struct MultiplayerView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var gameValues: GameValues

    // FETCH REQUESTS
    @FetchRequest(
        entity: Player.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \Player.name,
                ascending: true)
        ],
        predicate: NSPredicate(format: "type == %@", "multiplayer")
    ) private var allPlayers: FetchedResults<Player>
    
    @State private var playerName: String = ""
    @State private var playerNameExists: Bool = false
    @State private var isExceedingPlayerLimit: Bool = false
    @State private var isReadyToPlay: Bool = false
    
    private func addPlayer() {
        if allPlayers.count >= 5 {
            isExceedingPlayerLimit = true
        } else {
            if playerName != "" && playerName.count < 20 {
                if allPlayers.contains(where: { $0.name == playerName }) {
                    playerNameExists = true
                } else {
                    let player = Player(context: managedObjectContext)
                    player.id = UUID()
                    player.name = playerName
                    player.score = 0
                    player.isPlaying = true
                    player.type = "multiplayer"
                    playerName = ""
                    saveData()
                }
            }
        }
    }
    
    private func removePlayer(at offsets: IndexSet) -> Void {
        for index in offsets {
            let player = allPlayers[index]
            managedObjectContext.delete(player)
        }
        saveData()
    }
    
    private func saveData() -> Void {
        do {
            try managedObjectContext.update()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            VStack(alignment: .center, spacing: 20) {
                Text("Players: \(allPlayers.count)/5")
                    .modifier(MultiplayerViewTextModifier())
                HStack {
                    TextField("Player Name", text: $playerName)
                        .modifier(MultiplayerViewTextFieldModifier())
                        .onSubmit {
                            if allPlayers.count < 5 {
                                playerName = playerName.trimmingCharacters(in: .whitespacesAndNewlines)
                                addPlayer()
                            } else {
                                isExceedingPlayerLimit = true
                            }
                        }
                    Button(action: {
                        playerName = playerName.trimmingCharacters(in: .whitespacesAndNewlines)
                        addPlayer()
                    }) {
                        Image(systemName: "plus.circle")
                            .modifier(MultiplayerViewImageModifier())
                    }
                    .disabled(allPlayers.count >= 5)
                }
                .modifier(MultiplayerViewHStackModifier())
            }
            .modifier(MultiplayerViewVStackModifier())
            VStack(alignment: .center, spacing: 20) {
                ScrollView {
                    ForEach(Array(allPlayers.enumerated()), id: \.offset) { index, player in
                        HStack {
                            Text(player.name!)
                            Spacer()
                            Image(systemName: "trash")
                                .modifier(MultiplayerViewHStackImageModifier())
                                .onTapGesture() {
                                    removePlayer(at: IndexSet(integer: index))
                                }
                        }
                    }
                }
            }
            if allPlayers.count >= 2 {
                MultiplayerViewNextButtonView(buttonAction: {
                    isReadyToPlay = true
                }, buttonText: "Next", buttonIcon: "arrow.right.circle")
            }
        }
        .navigationDestination(isPresented: $isReadyToPlay) {
            CategoryView()
                .environmentObject(gameValues)
        }
        .modifier(MultiplayerViewVStackModifier())
        .modifier(MainViewBackgroundModifier())
        .alert("\(playerName) has already been added. Please choose a unique name for each player.", isPresented: $playerNameExists, actions: {
            Button("Got it", role: .cancel) {}
        })
        .alert("Sorry, the max number of players is five.", isPresented: $isExceedingPlayerLimit, actions: {
            Button("Got it", role: .cancel) {}
        })
    }
}
