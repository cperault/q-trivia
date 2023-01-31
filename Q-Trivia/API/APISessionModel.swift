//
//  APISessionModel.swift
//  Q-Trivia
//
//  Created by Christopher Perault on 1/30/23.
//

import Foundation

// upon successful session token request, API will return the following response:
// { "response_code": Int, "response_message": String, "token": String }
struct SessionToken: Codable {
    let response_code: ResponseCode
    let response_message: String
    let token: String
}

// upon resetting session token, API will return the following response:
// { "response_code:" Int, "token": String }
struct SessionTokenReset: Codable {
    let response_code: ResponseCode
    let token: String
}

enum ResponseCode: Int, Codable {
    case Success = 0 // Code 0
    case NoResults = 1 // Code 1: Insufficient questions; example = asking 50 questions for a category containing only 20 questions
    case InvalidParameter = 2 // Code 2
    case TokenNotFound = 3 // Code 3
    case TokenEmpty = 4 // Code 4: Session token needs to be reset
}

enum SessionTokenStatus: Int, Codable {
    case Empty = 0
    case Valid = 1
}
