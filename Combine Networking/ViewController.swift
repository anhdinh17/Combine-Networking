//
//  ViewController.swift
//  Combine Networking
//
//  Created by Anh Dinh on 5/20/24.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    var networkPublisher: AnyPublisher<[User], Error> = NetworkingManager.shared.fetchURLWithErrorHandling(URL(string: "https://jsonplaceholder.typicode.com/usersss")!)
    
    var cancellables = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call function
        // Which trigger value change
        networkPublisher
            .sink { completionStatus in
                switch completionStatus {
                case .finished:
                    print("Finished Publishing")
                case .failure(let error):
                    let networkError = error as? NetworkingError
                    switch networkError {
                    case .invalidURL:
                        print("Invalid URL")
                    case .invalidData:
                        print("Invalid Data")
                    case .invalidResponse:
                        print("Invalid Response")
                    case .unknown(let error):
                        print(error.localizedDescription)
                    default:
                        break
                    }
                }
            } receiveValue: { usersArray in
                print(usersArray)
            }
            .store(in: &cancellables)

    }
}

