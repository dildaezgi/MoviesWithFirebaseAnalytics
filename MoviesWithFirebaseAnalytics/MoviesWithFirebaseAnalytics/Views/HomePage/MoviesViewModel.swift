//
//  MoviesViewModel.swift
//  MoviesWithFirebaseAnalytics
//
//  Created by Dilda Ezgi Metincan Personal on 5.06.2023.
//

import Foundation

class MovieViewModel {
    private let apiKey = "2232c59c"
    
    func fetchSearchResults(searchTerm: String, completion: @escaping (Result<[MovieSearchResult], Error>) -> Void) {
        guard let url = URL(string: "http://www.omdbapi.com/?apikey=\(apiKey)&s=\(searchTerm)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let movieSearchResponse = try decoder.decode(MovieSearchResponse.self, from: data)
                completion(.success(movieSearchResponse.search))
                print("veri alindi")
                print(String(data: data, encoding: .utf8))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

