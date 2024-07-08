//
//  WebService.swift
//  CoffeeApp
//
//  Created by Raj.P, Varun (Cognizant) on 08/07/24.
//

import Foundation

struct Resource<T: Codable> {
    let url: URL
}

enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
}

class WebService {
    
    func load<T>(resource: Resource<T>, completion: @escaping(Result<T, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: resource.url) { data, response, err in
            guard let data = data, err == nil else {
                completion(.failure(.domainError))
                return
            }
            
            if let result = try? JSONDecoder().decode(T.self, from: data) {
                completion(.success(result))
            } else {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
}
