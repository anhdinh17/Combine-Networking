//
//  NetworkingManager.swift
//  Combine Networking
//
//  Created by Anh Dinh on 5/20/24.
//

import Foundation
import Combine

class NetworkingManager {
    static let shared = NetworkingManager()
    private init() {}
    
    func fetchURL<T: Codable>(_ url: URL) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ result in
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: result.data)
            })
            .eraseToAnyPublisher()
    }
}
