//
//  NetworkingManager.swift
//  Combine Networking
//
//  Created by Anh Dinh on 5/20/24.
//

import Foundation
import Combine

struct User: Codable {
    let id: Int
    let name: String
    let username: String
}

/** ---NOTE---
 - In the book, he creates a struct for Error.
 - I think it's a bit complicated so I just create an enum to do error handling.
 */

enum NetworkingError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case unknown(error: Error)
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "This is invalid URL error."
        case .invalidResponse:
            return "This is invalid RESPONSE ERROR."
        case .invalidData:
            return "This is INVALID DATA ERROR."
        case .unknown(let error):
            return "Sorry, we don't know this error lol."
        }
    }
}

class NetworkingManager {
    static let shared = NetworkingManager()
    private init() {}

    // This func returns a PUBLISHER
    // In this case, it's dataTaskPublisher
    func fetchURL<T: Codable>(_ url: URL) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ result in
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: result.data)
            })
            .eraseToAnyPublisher()
    }
    
    // ANOTHER FUNC
    // This way is easier to understand than .flatMap{}
    func fetchURLWithErrorHandling<T: Decodable>(_ url: URL) -> AnyPublisher<[T], Error> {
      URLSession.shared.dataTaskPublisher(for: url)
        .tryMap({ result in
          let decoder = JSONDecoder()
          guard let urlResponse = result.response as? HTTPURLResponse, (200...299).contains(urlResponse.statusCode) else {
              // Errors occur while decoding in tryMap are AUTOMATICALLY
              // forwarded to subscriber(.sink)
              throw NetworkingError.invalidResponse
          }

          return try decoder.decode([T].self, from: result.data)
        })
        .eraseToAnyPublisher()
    }
}
