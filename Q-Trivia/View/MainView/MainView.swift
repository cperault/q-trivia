//
//  MainView.swift
//  Q-Trivia
//
//  Created by Christopher Perault on 1/28/23.
//

import SwiftUI

struct MainView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var gameValues: GameValues
    
    @State private var isPlayingSolo: Bool = false
    @State private var isPlayingMulti: Bool = false
    @State private var isViewingScoreboard: Bool = false
    
    // FETCH REQUESTS
    @FetchRequest(
        entity: FinishedGame.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \FinishedGame.session,
                ascending: true)
        ]
    ) private var finishedGames: FetchedResults<FinishedGame>
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            // TITLE
            Text("Q-Trivia")
                .modifier(MainViewTitleModifier())
            
            // IMAGE
            ZStack {
                Image("brain")
                    .modifier(MainViewImageModifier())
            }
            .modifier(MainViewZStackModifier())
            
            // BUTTONS
            MainViewButtonView(
                buttonAction: {
                    isPlayingSolo = true
                },
                buttonText: "Quick Play",
                buttonIcon: "arrow.right.circle"
            )
            
            MainViewButtonView(
                buttonAction: {
                    isPlayingMulti = true
                },
                buttonText: "Multiplayer",
                buttonIcon: "arrow.right.circle"
            )
            
            if !finishedGames.isEmpty {
                MainViewButtonView(
                    buttonAction: {
                        isViewingScoreboard = true
                    },
                    buttonText: "Scoreboard",
                    buttonIcon: "arrow.right.circle"
                )
            }
        }
        .navigationDestination(isPresented: $isPlayingSolo) {
            CategoryView()
                .environmentObject(gameValues)
        }
        .navigationDestination(isPresented: $isPlayingMulti) {
            MultiplayerView()
                .environmentObject(gameValues)
        }
        .navigationDestination(isPresented: $isViewingScoreboard) {
            ScoreboardView()
                .environmentObject(gameValues)
        }
        .modifier(MainViewBackgroundModifier())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                SettingsButtonView()
                    .environmentObject(gameValues)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
