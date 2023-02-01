//
//  QuestionView.swift
//  Q-Trivia
//
//  Created by Christopher Perault on 1/28/23.
//

import SwiftUI

struct QuestionView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var gameValues: GameValues
    
    // FETCH REQUESTS
    @FetchRequest(
        entity: Game.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \Game.id,
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
    
    @State private var guesses: [String:Bool] = [:]
    @State private var isEndingGame: Bool = false
    @State var isPresentingConfirmation: Bool = false
    @State var allQuestionsAnswered: Bool = false
    @State private var answeredCount: Int = 0
    @State private var tabSelection: Int = 0
    
    @AppStorage("displayName") private var displayName = "SOLO PLAYER"
    @AppStorage("sessionToken") private var sessionToken = ""
    @AppStorage("sessionTokenStatus") private var sessionTokenStatus: SessionTokenStatus = .Empty
    
    private func fetchSessionToken() {
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
    
    private func getQuestions() {
        var queryParameters = [
            "amount": "\(gameValues.questionCount)",
            "category": "\(gameValues.selectedCategoryID)"
        ]
        
        if gameValues.gameMode == "multiplayer" && allPlayers.filter({ $0.type == "multiplayer" }).count > 0 {
            queryParameters["amount"] = "\(gameValues.questionCount * allPlayers.filter({ $0.type == "multiplayer" }).count)"
        }
        
        if sessionToken.isEmpty || sessionTokenStatus == .Empty {
            fetchSessionToken()
        }
        
        if sessionTokenStatus == .Valid && !sessionToken.isEmpty {
            queryParameters["token"] = sessionToken
        }
        
        URLSession.shared.requestWithParams(url: Constants.triviaQuestionURL, parameters: queryParameters, expectedEncodingType: QuestionAPIResponse.self) { (result: Result<QuestionAPIResponse, Error>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    switch response.response_code {
                    case 0:
                        sessionTokenStatus = .Valid
                    case 1, 2, 3, 4:
                        sessionTokenStatus = .Empty
                    default:
                        sessionTokenStatus = .Empty
                    }
                    gameValues.gameQuestions = response.results
                    prepareGame()
                }
            case .failure(let error):
                print("Could not retrieve questions from API. \(error.localizedDescription)")
            }
        }
    }
    
    private func assignPlayerToQuestion(question: inout QuestionModel, player: Player) -> Void {
        if let playerName = player.name {
            question.forPlayer = playerName
            question.hasAGuess = false
        }
    }
    
    private func updatePlayerInfo(for player: String, with points: Int) -> Void {
        var pointsTotal: Double = 0
        if let currentGame = (allGames.filter { $0.id == gameValues.currentGameSessionUUID }.first) {
            pointsTotal = currentGame.scores?[player] ?? 0
            pointsTotal += Double(points)
            currentGame.scores?[player] = Double(pointsTotal)
            saveData()
        }
    }
    
    private func prepareGame() {
        if gameValues.gameMode == "multiplayer" {
            let questionsDivided: [[QuestionModel]] = gameValues.gameQuestions.chunked(into: (gameValues.gameQuestions.count / allPlayers.filter{ $0.type == "multiplayer" }.count))
            var counter: Int = 0
            for (index, _) in Array(questionsDivided.enumerated()){
                for _ in questionsDivided[index] {
                    assignPlayerToQuestion(question: &gameValues.gameQuestions[counter], player: allPlayers.filter{ $0.type == "multiplayer" }[index])
                    counter += 1
                }
            }
        } else {
            let player = Player(context: managedObjectContext)
            player.name = displayName
            let playerID = UUID()
            player.id = playerID
            player.score = 0
            player.isPlaying = true
            player.type = "solo"
            
            for (index, _) in Array(gameValues.gameQuestions.enumerated()) {
                assignPlayerToQuestion(question: &gameValues.gameQuestions[index], player: player)
            }
            
            saveData()
        }
        
        // put questions in order
        gameValues.gameQuestions.enumerated().forEach { idx, _ in
            gameValues.gameQuestions[idx].questionOrder = idx
            gameValues.gameQuestions[idx].hasAGuess = false
        }
        
        gameValues.questions = gameValues.gameQuestions
    }
    
    private func endGame(finished: Bool) -> Void {
        let currentGameUUID = gameValues.currentGameSessionUUID
        let currentGame = allGames.filter { $0.id == currentGameUUID }.first
        
        if finished {
            var gameQuestions: [GameQuestion] = []
            
            gameValues.questions.enumerated().forEach { idx, question in
                let fgq = GameQuestion(context: managedObjectContext)
                fgq.questionOrder = Int16(idx)
                fgq.forGame = currentGameUUID
                let newGameQuestionID = UUID()
                fgq.id = newGameQuestionID
                fgq.category = question.category
                fgq.difficulty = question.difficulty
                fgq.question = question.question.htmlUnescape()
                fgq.correctAnswer = question.correct_answer
                fgq.incorrectAnswers = question.incorrect_answers
                fgq.forPlayer = question.forPlayer ?? "unknown"
                
                gameQuestions.append(fgq)
            }
            
            saveData()
            
            currentGame?.isFinished = true
            let finishedGames = FinishedGame(context: managedObjectContext)
            let currentDate = Date.now
            finishedGames.session = currentDate
            finishedGames.id = currentGameUUID
            finishedGames.players = currentGame?.players
            finishedGames.scores = currentGame?.scores
            finishedGames.gameQuestions = Set(gameQuestions.map { $0 }) as? NSSet
            
            saveData()
            
            gameValues.selectedGameID = currentGameUUID
            allQuestionsAnswered = true
        } else {
            // don't save the game, but do delete current game
            managedObjectContext.delete(currentGame!)
            saveData()
            isEndingGame = true
        }
        
        answeredCount = 0
    }
    
    private func newGame() -> Void {
        // create new game
        let game = Game(context: managedObjectContext)
        let gameID = UUID()
        game.id = gameID
        game.isFinished = false
        
        if gameValues.gameMode == "multiplayer" {
            // get current players
            let players = allPlayers.filter { $0.type == "multiplayer" }.compactMap { $0.name }
            
            // create empty scores for each player
            var scores: [String: Double] = [:]
            
            for player in players {
                scores[player] = 0
            }
            
            game.players = players
            game.scores = scores
        } else {
            game.players = [displayName]
            game.scores = [displayName: 0]
        }
        
        game.type = gameValues.gameMode
        game.session = Date.now
        
        gameValues.currentGameSessionUUID = gameID
        
        saveData()
    }
    
    private func processAnswer(with index: Int, using answer: String, for question: QuestionModel) {
        if guesses["\(String(describing: index))"] != true {
            answeredCount += 1
            guesses["\(String(describing: index))"] = true
            
            if answer == question.correct_answer {
                updatePlayerInfo(for: question.forPlayer ?? "" , with: 1)
            }
            
            gameValues.gameQuestions[index].hasAGuess = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                // only end game if all questions have truly been answered
                if answeredCount == gameValues.questions.count {
                    endGame(finished: true)
                } else {
                    // go to first unanswered question
                    let nextQuestion = nextQuestion()
                    let newQuestionIndex = gameValues.questions.firstIndex(of: nextQuestion)!
                    tabSelection = newQuestionIndex
                }
            }
        }
    }
    
    private func nextQuestion() -> QuestionModel {
        // find all questions without a guess
        let unansweredQuestion = gameValues.gameQuestions.filter { $0.hasAGuess == false }.sorted { $0.questionOrder! < $1.questionOrder! }.first
        
        let nextQuestion = gameValues.questions.filter { $0.question == unansweredQuestion?.question }.first!
        
        return nextQuestion
    }
    
    private func answerColor(for index: Int, with question: (String?, String?)) -> Color {
        if guesses["\(index)"] == true {
            if question.0 == question.1 {
                return .correctAnswerColor
            } else {
                return Color.red
            }
        } else {
            return Color.primary
        }
    }
    
    private func saveData() {
        do {
            try managedObjectContext.update()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Spacer()
            Image(getCategoryNameAndIcon(categoryName: gameValues.selectedCategoryName)[1])
            TabView(selection: $tabSelection) {
                ForEach(Array(gameValues.gameQuestions.enumerated()), id: \.offset) { index, question in
                    VStack {
                        Text(question.questionParsed)
                            .font(.title2)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal)
                            .padding(.vertical)
                        ForEach(question.allAnswers, id: \.self) { answer in
                            VStack(alignment: .center) {
                                Button(action: {
                                    processAnswer(with: index, using: answer, for: question)
                                }) {
                                    Text(answer.htmlUnescape())
                                        .foregroundColor(Color.primary)
                                        .frame(minWidth: 100, maxWidth: .infinity, minHeight: 44, maxHeight: 44, alignment: .center)
                                        .cornerRadius(9)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 9).stroke(answerColor(for: index, with: (answer, question.correct_answer)), lineWidth: 2)
                                        )
                                }
                                .tag(index)
                            }
                        }
                        Text(gameValues.gameMode == "multiplayer" ? "Player's Turn: \(question.forPlayer ?? "")" : "")
                    }
                    .padding(30)
                    .frame(minHeight: 0, maxHeight: .infinity)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            Spacer()
        }
        .navigationDestination(isPresented: $isEndingGame) {
            MainView()
                .environmentObject(gameValues)
        }
        .navigationDestination(isPresented: $allQuestionsAnswered) {
            ScoreboardDetailsView(isViewingFromFinishedGame: true)
                .environmentObject(gameValues)
        }
        .onAppear {
            getQuestions()
            newGame()
            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(.primary)
            UIPageControl.appearance().pageIndicatorTintColor = UIColor(.primary).withAlphaComponent(0.2)
        }
        .onDisappear(perform: {
            UIPageControl.appearance().currentPageIndicatorTintColor = nil
            UIPageControl.appearance().pageIndicatorTintColor = nil
        })
        .modifier(MainViewBackgroundModifier())
        .navigationBarBackButtonHidden(true)
        .toolbar {
            EndGameButtonview(buttonAction: {
                isPresentingConfirmation = true
            }, buttonIcon: "stop.circle")
        }
        .alert("Do you wish to end this game? Your score will not be saved.", isPresented: $isPresentingConfirmation, actions: {
            Button("Yes") {
                endGame(finished: false)
            }
            Button("Cancel", role: .cancel) {}
        })
    }
}
