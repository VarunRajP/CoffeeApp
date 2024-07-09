//
//  WebService.swift
//  CoffeeApp
//
//  Created by Raj.P, Varun (Cognizant) on 08/07/24.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}
struct Resource<T: Codable> {
    let url: URL
    var httpMethod: HttpMethod = .get
    var body: Data? = nil
}

enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
}

class WebService {
    
    func load<T>(resource: Resource<T>, completion: @escaping(Result<T, NetworkError>) -> Void) {
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.httpMethod.rawValue
        request.httpBody = resource.body
        request.addValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, err in
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
