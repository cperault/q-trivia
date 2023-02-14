//
//  Extensions.swift
//  Q-Trivia
//
//  Created by Christopher Perault on 1/28/23.
//

import CoreData
import SwiftUI

extension Color {
    static let correctAnswerColor = Color("DarkGreen")
    static let lightOrDarkMode = Color("ColorMode")
}

extension NSManagedObjectContext {
    func update() throws {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self
        
        context.perform({
            do {
                try context.save()
            } catch {
                print("Uh oh...couldn't update NSManagedObjectContext: \(error.localizedDescription)")
            }
        })
    }
}

protocol ImageModifier {
    associatedtype Body: View
    
    func body(image: Image) -> Self.Body
}

extension Image {
    func modifier<M>(_ modifier: M) -> some View where M: ImageModifier {
        modifier.body(image: self)
    }
}

extension URLSession {
    enum CustomError: Error {
        case invalidURL
        case invalidData
    }
    
    func request<S: Codable>(url: String, expectedEncodingType: S.Type, completion: @escaping (Result<S, Error>) -> Void) {
        if url == "" {
            completion(.failure(CustomError.invalidURL))
            return
        }
        
        let urlParsed = URLComponents(string: url)
        let request = URLRequest(url: (urlParsed?.url)!)
        
        URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(CustomError.invalidData))
                }
                return
            }
            do {
                let result: S = try JSONDecoder().decode(expectedEncodingType, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func requestWithParams<S: Codable>(url: String, parameters: [String: String], expectedEncodingType: S.Type, completion: @escaping (Result<S, Error>) -> Void) {
        if url == "" {
            completion(.failure(CustomError.invalidURL))
            return
        }
        
        var components = URLComponents(string: url)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)

        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(CustomError.invalidData))
                }
                return
            }
            do {
                let result: S = try JSONDecoder().decode(expectedEncodingType, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

// splits up questions into chunks based on number of players; 3 players doing 2 questions will yield 3 sets of questions containing 2 questions per set
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8) else {
            return nil
        }
        do {
            let result = try JSONDecoder().decode([Element].self, from: data)
            self = result
        } catch {
            return nil
        }
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

extension UUID: RawRepresentable {
    public var rawValue: String {
        self.uuidString
    }
    
    public typealias RawValue = String
    
    public init?(rawValue: RawValue) {
        self.init(uuidString: rawValue)
    }
}
