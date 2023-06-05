//
//  Movies.swift
//  MoviesWithFirebaseAnalytics
//
//  Created by Dilda Ezgi Metincan Personal on 5.06.2023.
//

import Foundation

// MARK: - MovieSearchResponse
struct MovieSearchResponse: Codable {
    let search: [MovieSearchResult]
    let totalResults: String
    let Response: String

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults = "totalResults"
        case Response = "Response"
    }
}

// MARK: - MovieSearchResult
struct MovieSearchResult: Codable {
    let title: String?
    let year: String?
    let imdbID: String?
    let type: String?
    let poster: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
}
// MARK: - MovieDetail
struct MovieDetail: Codable {
    let title, year, rated, released: String
    let runtime, genre, director, writer: String
    let actors, plot, language, country: String
    let awards: String
    let poster: String
    let ratings: [Rating]
    let metascore, imdbRating, imdbVotes, imdbID: String
    let type, dvd, boxOffice, production: String
    let website, response: String
}

// MARK: - Rating
struct Rating: Codable {
    let Source, Value: String
}

