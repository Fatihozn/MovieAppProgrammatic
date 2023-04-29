//
//  Video.swift
//  BigMoviesAppProgrammatic
//
//  Created by Fatih Özen on 23.03.2023.
//

import Foundation

struct Video: Decodable {
    var id: Int?
    var results: [VideoResults]?
    
    var _results: [VideoResults] {
        results ?? []
    }
}

struct VideoResults : Decodable {
    var key: String?
    
    var _key: String {
        key ?? ""
    }
}
