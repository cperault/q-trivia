//
//  QuestionModel.swift
//  Q-Trivia
//
//  Created by Christopher Perault on 1/28/23.
//

import HTMLEntities

struct QuestionModel: Identifiable, Codable, Hashable {
    var id: Int?
    
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
    var hasAGuess: Bool? = false
    var forPlayer: String?
    var questionOrder: Int?
    var questionParsed: String {
        return (question.htmlUnescape())
    }
    var allAnswers: [String] {
        var answers = combineAndShuffleAnswers(correctAnswer: correct_answer, incorrectAnswers: incorrect_answers)
        
        if answers.count == 2 {
            answers = answers.sorted(by: {$0 > $1})
        } else {
            answers = answers.sorted()
        }

        return answers
    }
}

struct QuestionAPIResponse: Codable {
    let response_code: Int
    var results: [QuestionModel]
}

func combineAndShuffleAnswers(correctAnswer: String, incorrectAnswers: [String]) -> [String] {
    var combined: [String] = []
    
    combined.append(correctAnswer)
    
    incorrectAnswers.forEach { i in
        combined.shuffle()
        combined.append(i)
    }
    
    return combined.shuffled()
}
