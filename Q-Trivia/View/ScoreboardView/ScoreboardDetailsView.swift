//
//  ScoreboardDetailsView.swift
//  Q-Trivia
//
//  Created by Christopher Perault on 1/29/23.
//

import SwiftUI

struct ScoreboardDetailsView: View {
    @EnvironmentObject var gameValues: GameValues

    // FETCH REQUESTS
    @FetchRequest(
        entity: FinishedGame.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \FinishedGame.id,
                ascending: true)
        ]
    ) private var allFinishedGames: FetchedResults<FinishedGame>

    @FetchRequest(
        entity: Game.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \Game.id,
                ascending: true)
        ]
    ) private var allGames: FetchedResults<Game>
    
    @State var isViewingFromFinishedGame: Bool
    @State private var isReturningHome: Bool = false
    
    private func scores() -> [String:Double] {
        var gameScores: [String:Double] = [:]

        for g in (allGames.filter { $0.id == gameValues.selectedGameID }) {
            if let scores = g.scores {
                gameScores = scores
            }
        }

        return gameScores
    }
    
    private func questions() -> [GameQuestion] {
        var gameQuestions: [GameQuestion] = []
        
        let finishedGame = (allFinishedGames.filter { $0.id == gameValues.selectedGameID })
        
        for game in finishedGame {
            for question in game.gameQuestions?.allObjects as! [GameQuestion] {
                gameQuestions.append(question)
            }
        }
        
        return gameQuestions.sorted { $0.questionOrder < $1.questionOrder }
    }
    
    private func allAnswers(for question: GameQuestion) -> [String] {
        var answers: [String] = []
        
        answers = combineAndShuffleAnswers(correctAnswer: question.correctAnswer!, incorrectAnswers: question.incorrectAnswers!)
        
        if answers.count == 2 {
            answers = answers.sorted(by: {$0 > $1})
        } else {
            answers = answers.sorted()
        }
        
        return answers
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            List {
                ForEach(scores().sorted {$0.key < $1.key}, id: \.key) { key, value in
                    HStack {
                        Text("\(key.uppercased())")
                        Spacer()
                        Text("\(String(format: "%.0f", value)) \(value == 0 || value > 1 ? "points" : "point")")
                    }
                }
                ForEach(questions().sorted(by: {$0.questionOrder < $1.questionOrder})) { q in
                    Section(header: Text(q.forPlayer!)) {
                        QuestionItemRow(question: q.question!, answers: allAnswers(for: q))
                    }
                }
            }
            .modifier(MainViewBackgroundModifier())
            .navigationBarBackButtonHidden(isViewingFromFinishedGame)
            .toolbar {
                if isViewingFromFinishedGame {
                    ScoreboardViewHomeButtonView(buttonAction: {
                        isReturningHome = true
                    }, buttonIcon: "house.circle")
                }
            }
        }
        .navigationDestination(isPresented: $isReturningHome) {
            MainView()
                .environmentObject(gameValues)
        }
    }
}
