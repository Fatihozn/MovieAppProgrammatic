//
//  APIURLs.swift
//  BigMoviesAppProgrammatic
//
//  Created by Fatih Özen on 21.03.2023.
//

import Foundation

enum APIURLs {
    
    static func getPopularMovies(page: Int) -> String {
        "https://api.themoviedb.org/3/movie/popular?api_key=adc8a5bdc6760c74947ac29f385ebd15&language=en-US&page=\(page)"
    }
    
    static func getNowPlayingMovies(page: Int) -> String {
        "https://api.themoviedb.org/3/movie/now_playing?api_key=adc8a5bdc6760c74947ac29f385ebd15&language=en-US&page=\(page)"
    }
    
    static func getUpcomingMovies(page: Int) -> String {
        "https://api.themoviedb.org/3/movie/upcoming?api_key=adc8a5bdc6760c74947ac29f385ebd15&language=en-US&page=\(page)"
    }
    
    static func getTopRatedMovies(page: Int) -> String {
        "https://api.themoviedb.org/3/movie/top_rated?api_key=adc8a5bdc6760c74947ac29f385ebd15&language=en-US&page=\(page)"
    }
    
    static func getPopularTV(page: Int) -> String {
        "https://api.themoviedb.org/3/tv/popular?api_key=adc8a5bdc6760c74947ac29f385ebd15&language=en-US&page=\(page)"
    }
    
    static func getNowPlayingTV(page: Int) -> String {
        "https://api.themoviedb.org/3/tv/airing_today?api_key=adc8a5bdc6760c74947ac29f385ebd15&language=en-US&page=\(page)"
    }
    
    static func getUpcommingTV(page: Int) -> String {
        "https://api.themoviedb.org/3/tv/on_the_air?api_key=adc8a5bdc6760c74947ac29f385ebd15&language=en-US&page=\(page)"
    }
    
    static func getTopRatingTV(page: Int) -> String {
        "https://api.themoviedb.org/3/tv/top_rated?api_key=adc8a5bdc6760c74947ac29f385ebd15&language=en-US&page=\(page)"
    }
    
    static func downloadImage(posterPath: String) -> String {
        "https://image.tmdb.org/t/p/w500\(posterPath)"
    }
    
    static func getDetailTV(id: Int) -> String {
        "https://api.themoviedb.org/3/tv/\(id)?api_key=adc8a5bdc6760c74947ac29f385ebd15&language=en-US"
    }
    
    static func getVideoUrlTV(id: Int) -> String {
        "https://api.themoviedb.org/3/tv/\(id)/videos?api_key=adc8a5bdc6760c74947ac29f385ebd15&language=en-US"
    }
    
    static func getSimilarTV(id: Int, page: Int) -> String {
        "https://api.themoviedb.org/3/tv/\(id)/similar?api_key=adc8a5bdc6760c74947ac29f385ebd15&language=en-US&page=\(page)"
    }
    
    static func getDetail(id: Int) -> String {
        "https://api.themoviedb.org/3/movie/\(id)?api_key=adc8a5bdc6760c74947ac29f385ebd15&language=en-US"
    }
    
    static func getVideoUrl(id: Int) -> String {
        "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=adc8a5bdc6760c74947ac29f385ebd15"
    }
    
    static func getSimilarMovies(id: Int, page: Int) -> String {
        "https://api.themoviedb.org/3/movie/\(id)/similar?api_key=adc8a5bdc6760c74947ac29f385ebd15&language=en-US&page=\(page)"
    }
    
    static func getCast(id: Int) -> String {
        "https://api.themoviedb.org/3/movie/\(id)/credits?api_key=adc8a5bdc6760c74947ac29f385ebd15&language=en-US"
    }
    
    static func getSearch(text: String, page: Int) -> String {
        "https://api.themoviedb.org/3/search/movie?api_key=adc8a5bdc6760c74947ac29f385ebd15&language=en-US&query=\(text)&page=\(page)&include_adult=false"
    }
}
