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
    var name: String?
    var character: String?
    var profilePath: String?
    
    enum CodingKeys: String, CodingKey{
        case name
        case character
        case profilePath = "profile_path"
    }
    
    var _name: String {
        name ?? ""
    }
    var _character: String {
        character ?? ""
    }
    var _profilePath: String {
        profilePath ?? ""
    }
}
