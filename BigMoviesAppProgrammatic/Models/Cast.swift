//
//  Cast.swift
//  BigMoviesAppProgrammatic
//
//  Created by Fatih Özen on 28.03.2023.
//

import Foundation

struct Cast: Decodable {
    var cast: [CastResult]?
}

struct CastResult: Decodable {
    var id: Int?
    var name: String?
    var birthday: String?
    var placeOfBirth: String?
    var character: String?
    var profilePath: String?
    var biography: String?
    var departmant: String?
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case birthday
        case placeOfBirth = "place_of_birth"
        case character
        case profilePath = "profile_path"
        case biography
        case departmant = "known_for_department"
    }
    
    var _id: Int {
        id ?? .zero
    }
    var _name: String {
        name ?? ""
    }
    var _birthday: String {
        birthday ?? "birthday is unknown"
    }
    var _placeOfBirth: String {
        placeOfBirth ?? "place of birth is unknown"
    }
    var _character: String {
        character ?? ""
    }
    var _profilePath: String {
        profilePath ?? ""
    }
    var _biography: String {
        biography ?? "There is no biography"
    }
    var _departmant: String {
        departmant ?? "departmant is unknown"
    }
}

struct CastMovie: Decodable {
    var cast: [MovieResult]?
}
//struct CastCredits: Decodable {
//    var id: Int?
//    var posterPath: String?
//
//    enum CodingKeys: String, CodingKey{
//        case id
//        case posterPath = "poster_path"
//    }
//
//    var _id: Int {
//        id ?? .zero
//    }
//    var _posterPath: String {
//        posterPath ?? ""
//    }
//}

