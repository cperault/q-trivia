//
//  MainView.swift
//  Q-Trivia
//
//  Created by Christopher Perault on 1/28/23.
//

import SwiftUI

struct MainView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @StateObject var networkEnforcement = NetworkEnforcement()
    
    @State private var isPlayingSolo: Bool = false
    @State private var isPlayingMulti: Bool = false
    @State private var isViewingScoreboard: Bool = false
    @State private var isNotConnectedToNetwork: Bool = false
    
    @AppStorage("sessionToken") private var sessionToken = ""
    @AppStorage("sessionTokenStatus") private var sessionTokenStatus: SessionTokenStatus = .Empty
    
    @AppStorage("gameMode") private var gameMode = "solo"
    
    // FETCH REQUESTS
    @FetchRequest(
        entity: FinishedGame.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \FinishedGame.session,
                ascending: true)
        ]
    ) private var finishedGames: FetchedResults<FinishedGame>
    
    @FetchRequest(
        entity: Game.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \Game.session,
                ascending: true)
        ]
    ) private var allGames: FetchedResults<Game>
    
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
                    gameMode = "solo"
                    isPlayingSolo = true
                },
                buttonText: "Quick Play",
                buttonIcon: "arrow.right.circle"
            )
            
            MainViewButtonView(
                buttonAction: {
                    gameMode = "multiplayer"
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
        }
        .navigationDestination(isPresented: $isPlayingMulti) {
            MultiplayerView()
        }
        .navigationDestination(isPresented: $isViewingScoreboard) {
            ScoreboardView()
        }
        .onAppear {
            if sessionToken.isEmpty || sessionTokenStatus == .Empty {
                URLSession.shared.request(url: Constants.sessionRequestURL, expectedEncodingType: SessionToken.self) { (result: Result<SessionToken, Error>) in
                    switch result {
                    case .success(let response):
                        sessionToken = response.token
                        sessionTokenStatus = .Valid
                    case .failure(let error):
                        sessionToken = ""
                        sessionTokenStatus = .Empty
                        print("Could not retrieve session token from API. \(error.localizedDescription)")
                    }
                }
            }
            
            // we want to delete any games that were created but not finished (app crash or app being force-quit either by user or OS)
            let currentGames = allGames.filter { !$0.isFinished }
            if currentGames.count > 0 {
                for game in currentGames {
                    managedObjectContext.delete(game)
                    do {
                        try managedObjectContext.update()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        .modifier(MainViewBackgroundModifier())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                SettingsButtonView()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
