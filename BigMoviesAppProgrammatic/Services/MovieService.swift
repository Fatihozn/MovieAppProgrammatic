//
//  MovieService.swift
//  BigMoviesAppProgrammatic
//
//  Created by Fatih Özen on 19.03.2023.
//

import Foundation

final class MovieService {
    
    func downloadMovies(url: String, completion: @escaping ([MovieResult]?) -> () ) {
        guard let url = URL(string: url) else { return }
        
        NetworkManager.shared.download(url: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                completion(self.handleWithData(data))
            case .failure(let error):
                self.handleWithError(error)
            }
        }
        
    }
    
    func downloadDetail(url: String,id: Int, completion: @escaping (MovieResult?, Data) -> () ) {
        guard let url = URL(string: url) else { return }
        
        NetworkManager.shared.download(url: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                completion(self.handleWithData(data), data)
            case .failure(let error):
                self.handleWithError(error)
            }
        }
    }
    
    func downloadCast(url: String, completion: @escaping ([CastResult]?) -> () ){
        guard let url = URL(string: url) else { return }
        
        NetworkManager.shared.download(url: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                completion(self.handleWithData(data))
            case .failure(let error):
                self.handleWithError(error)
            }
        }
    }
    
    func downloadCastDetail(url: String, completion: @escaping (CastResult?) -> () ){
        guard let url = URL(string: url) else { return }
        
        NetworkManager.shared.download(url: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                completion(self.handleWithData(data))
            case .failure(let error):
                self.handleWithError(error)
            }
        }
    }
    
    func downloadVideo(url: String, completion: @escaping ([VideoResults]?) -> () ){
        guard let url = URL(string: url) else { return }
        
        NetworkManager.shared.download(url: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                completion(self.handleWithData(data))
            case .failure(let error):
                self.handleWithError(error)
            }
        }
    }
    
    func donwloadCastMovie(url: String, completion: @escaping ([MovieResult]?) -> () ){
        guard let url = URL(string: url) else { return }
        
        NetworkManager.shared.download(url: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                completion(self.handleWithDataCast(data))
            case .failure(let error):
                self.handleWithError(error)
            }
        }
    }
    
    private func handleWithError(_ error: Error) {
        print(error.localizedDescription)
    }
    
    private func handleWithData(_ data: Data) -> [MovieResult]? {
        do {
            let movie = try JSONDecoder().decode(Movie.self, from: data)
            return movie.results
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func handleWithData(_ data: Data) -> (MovieResult?) {
        do {
            let movieResult = try JSONDecoder().decode(MovieResult.self, from: data)
            return movieResult
        } catch  {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func handleWithData(_ data: Data) -> [CastResult]? {
        do {
            let cast = try JSONDecoder().decode(Cast.self, from: data)
            return cast.cast
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func handleWithData(_ data: Data) -> CastResult? {
        do{
            let castResult = try JSONDecoder().decode(CastResult.self, from: data)
            return castResult
        }catch{
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func handleWithDataCast(_ data: Data) -> [MovieResult]? {
        do {
            let castMovie = try JSONDecoder().decode(CastMovie.self, from: data)
            return castMovie.cast
        } catch {
            print(error)
            return nil
        }
    }
    
    private func handleWithData(_ data: Data) -> [VideoResults]? {
        do {
            let video = try JSONDecoder().decode(Video.self, from: data)
            return video.results
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
