//
//  ScoreboardView.swift
//  Q-Trivia
//
//  Created by Christopher Perault on 1/28/23.
//

import SwiftUI
import HTMLEntities

struct QuestionItemRow: View {
    let question: String
    let answers: [String]
    
    init(question: String, answers: [String]) {
        self.question = question
        self.answers = answers
    }
    
    var body: some View {
        Text(question.htmlUnescape()).bold()
        ForEach(answers, id: \.self) { answer in
            Text(answer.htmlUnescape())
        }
    }
}

struct ScoreboardView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var gameValues: GameValues
    
    // FETCH REQUESTS
    @FetchRequest(
        entity: FinishedGame.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \FinishedGame.session,
                ascending: true)
        ]
    ) private var allFinishedGames: FetchedResults<FinishedGame>
    
    @FetchRequest(
        entity: Game.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \Game.session,
                ascending: true)
        ]
    ) private var allGames: FetchedResults<Game>
    
    @FetchRequest(
        entity: Player.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \Player.id,
                ascending: true)
        ]
    ) private var allPlayers: FetchedResults<Player>
    
    @FetchRequest(
        entity: GameQuestion.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \GameQuestion.id,
                ascending: true)
        ]
    ) private var allFinishedGameQuestions: FetchedResults<GameQuestion>
    
    @State private var isClearingScoreboard: Bool = false
    @State private var isViewingScoreboardDetails: Bool = false
    
    private func showRecentGameDetails(game: Game) -> some View {
        return HStack {
            if let session = game.session {
                Text("\(session.formatted(.dateTime.day().month(.twoDigits).year(.twoDigits).hour().minute()))")
                if let players = game.players,
                   let playerCount = players.count {
                    Spacer()
                    Text("\(playerCount) \(playerCount > 1 ? "players" : "player")")
                }
                Spacer()
                ScoreboardViewDetailButtonView(buttonAction: {
                    if let gameID = game.id {
                        gameValues.selectedGameID = gameID
                        isViewingScoreboardDetails = true
                    }
                }, buttonText: nil, buttonIcon: "arrow.right.circle")
            }
        }
    }
    
    private func clearScoreboard() -> Void {
        if allGames.count > 0 {
            for game in allGames {
                managedObjectContext.delete(game)
            }

            saveData()
        }
        
        if allPlayers.count > 0 {
            for player in allPlayers {
                managedObjectContext.delete(player)
            }

            saveData()
        }
        
        if allFinishedGames.count > 0 {
            for finishedGame in allFinishedGames {
                managedObjectContext.delete(finishedGame)
            }

            saveData()
        }
        
        if allFinishedGameQuestions.count > 0 {
            for finishedGameQuestion in allFinishedGameQuestions {
                managedObjectContext.delete(finishedGameQuestion)
            }
            
            saveData()
        }

        DispatchQueue.main.async {
            if allGames.isEmpty {
                presentationMode.wrappedValue.dismiss()
            }
        }
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
            List {
                // SOLO GAME SCORES
                if allGames.filter { $0.type == "solo" }.count > 0 {
                    Section(header: Text("Solo Games")) {
                        ForEach(Array(allGames.filter { $0.type == "solo" }.enumerated()), id: \.offset) { index, game in
                            showRecentGameDetails(game: game)
                        }
                    }
                }
                
                // MULTIPLAYER GAME SCORES
                if allGames.filter { $0.type == "multiplayer" }.count > 0 {
                    Section(header: Text("Multiplayer Games")) {
                        ForEach(Array(allGames.filter { $0.type == "multiplayer" }.enumerated()), id: \.offset) { index, game in
                            showRecentGameDetails(game: game)
                        }
                    }
                }
            }
            .modifier(ScoreboardViewListBackgroundModifier())
        }
        .navigationTitle("Scoreboard")
        .navigationDestination(isPresented: $isViewingScoreboardDetails) {
            if !gameValues.selectedGameID.uuidString.isEmpty {
                ScoreboardDetailsView(isViewingFromFinishedGame: false)
                    .environmentObject(gameValues)
            }
        }
        .padding(20)
        .modifier(MainViewBackgroundModifier())
        .toolbar {
            ScoreboardViewDeleteScoresButtonView(buttonAction: {
                isClearingScoreboard = true
            }, buttonIcon: "trash")
        }
        .alert("This will clear the scoreboard and take you back to the main menu. This deletion cannot be undone. Are you sure?", isPresented: $isClearingScoreboard, actions: {
            Button("Erase all gameplay data") {
                clearScoreboard()
            }
            Button("Cancel", role: .cancel) {}
        })
    }
}
