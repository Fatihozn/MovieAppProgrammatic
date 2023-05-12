//
//  Movie.swift
//  BigMoviesAppProgrammatic
//
//  Created by Fatih Özen on 21.03.2023.
//

import Foundation

struct Movie: Decodable {
    var results: [MovieResult]?
}

struct MovieResult: Decodable {
    var id, numberOfSeasons, episodes: Int?
    var posterPath: String?
    var title, overview, releaseDate, name, firstAirDate, mediaType: String?
    var genres: [kategori]?
    var voteAverage: Double?
    
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case title
        case overview
        case releaseDate = "release_date"
        case genres
        case name
        case voteAverage = "vote_average"
        case numberOfSeasons = "number_of_seasons"
        case firstAirDate = "first_air_date"
        case episodes = "number_of_episodes"
        case mediaType = "media_type"
    }
    
    var _id: Int {
        id ?? Int.min
    }
    
    var _posterPath: String {
        posterPath ?? ""
    }
    
    var _title: String {
        title ?? "There is no title"
    }
    
    var _name: String {
        name ?? "There is no name"
    }
    
    var _overview: String {
        overview ?? "There is no overview"
    }
    
    var _releaseDate: String {
        releaseDate ?? "There is no date"
    }
    
    var _voteAverage: Double {
        voteAverage ?? 0
    }
    
    var _genres: [kategori] {
        genres ?? []
    }
    
    var _firstAirDate: String {
        firstAirDate ?? "There is no date"
    }
    
    var _numberOfSeasons: Int {
        numberOfSeasons ?? 0
    }
    
    var _episodes: Int {
        episodes ?? 0
    }
    
    var _mediaType: String {
        mediaType ?? ""
    }
    
}

struct kategori: Decodable {
    var id: Int?
    var name: String?
    
    var _id: Int {
        id ?? Int.min
    }
    var _name: String {
        name ?? ""
    }
}
