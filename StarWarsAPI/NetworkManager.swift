//
//  NetworkManager.swift
//  StarWarsAPI
//
//  Created by Manyuchi, Carrington C on 2025/01/19.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    let baseURL = "https://swapi.dev/api/people/?format=json"
    

    //MARK: - ** Option 1: A simple Network call
    func StandardfetchingData(completion: @escaping ([Person]?) -> Void) {
        guard let apiUrl = URL(string: baseURL) else { return }
        
        let task = URLSession.shared.dataTask(with: apiUrl) { data, httpResponse, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            
            guard let httpResponse = httpResponse as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Non HTTP response")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data returned")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(GetPeopleListResponse.self, from: data)
                completion(response.results)
                
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
    
    //MARK: - ** Option 2: Network call with result type
    
    func networkCallWithResultType(completion: @escaping (Result<[Person], PersonError>) -> Void) {
        guard let apiURL = URL(string: baseURL) else { return }
        
        let task = URLSession.shared.dataTask(with: apiURL) { data, httpResponse, error in
            
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.generalError))
            }
            
            guard let  httpResponse = httpResponse as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.generalError))
                return
            }
           
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(GetPeopleListResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(.decodingFailed))
            }
        }
        task.resume()
    }
    
    
    //MARK: - ** Option 3: Network call with ASync
    
    func networkWithASync() async throws -> [Person] {
        guard let apiURL = URL(string: baseURL) else { return [] }
        
        let (data, httpResponse) = try await URLSession.shared.data(from: apiURL)
        
        guard let httpResponse = httpResponse as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return []
        }
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(GetPeopleListResponse.self, from: data)
        return response.results
    }
}


enum PersonError: Error {
    case invalidResponse
    case decodingFailed
    case generalError
}
