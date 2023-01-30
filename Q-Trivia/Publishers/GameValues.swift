//
//  GameValues.swift
//  Q-Trivia
//
//  Created by Christopher Perault on 1/28/23.
//

import SwiftUI
import CoreData

class GameValues: ObservableObject {
    @Published var questionCount: Int = 4
    @Published var maxQuestionCount: Int = 10
    @Published var gameMode: String = "solo"
    
    @Published var selectedCategoryID: Int = 0
    @Published var selectedCategoryName: String = ""
    @Published var questionIndex: Int = 0
    
    @Published var currentGameSessionUUID: UUID = UUID()
    @Published var selectedGameID: UUID = UUID()
    @Published var isEndingGame: Bool = false
    
    @Published var gameQuestions: [QuestionModel] = [QuestionModel]()
    @Published var questions: [QuestionModel] = [QuestionModel]()
}
