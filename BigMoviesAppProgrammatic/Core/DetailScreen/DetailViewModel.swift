//
//  DetailViewModel.swift
//  BigMoviesAppProgrammatic
//
//  Created by Fatih Özen on 22.03.2023.
//

import Foundation

protocol DetailViewModelProtocol {
    var view: DetailScreenProtocol? { get set }
    
    func viewDidload()
    func getSimilarMovies(url: String)
}

final class DetailViewModel {
    
    weak var view: DetailScreenProtocol?
    private let service = MovieService()
    var moviesList = [MovieResult]()
    var castList = [CastResult]()
    var videoUrl = ""
    var page = 1
    var shouldMoreData = true
}

extension DetailViewModel: DetailViewModelProtocol {
    
    func viewDidload() {
        view?.configureVC()
        view?.configureInfoView()
        view?.configureVideo()
        view?.configureCast()
        view?.configureSimilarMovies()
        view?.getMovie()
        view?.getCast()
        
    }
    
    func getSimilarMovies(url: String) {
        shouldMoreData = false
        service.downloadMovies(url: url) { [weak self] returnedList in
            guard let self = self else { return }
            guard let returnedList = returnedList else { return }
            
            self.moviesList.append(contentsOf: returnedList)
            self.view?.reloadCollectionView()
            self.page += 1
            self.shouldMoreData = true
        }
    }
    
    func getCast(url: String) {
        service.downloadCast(url: url) { [weak self] returnedCast in
            guard let self = self else { return }
            guard let returnedCast = returnedCast else { return }
            
            self.castList.append(contentsOf: returnedCast)
            self.view?.reloadCastCollectionView()
            
        }
    }
    
    func getDetail(id: Int) {
        service.downloadDetail(id: id) { [weak self] returnedDetail in
            guard let self = self else { return }
            guard let returnedDetail = returnedDetail else { return }
            
            self.view?.navigateToDetail(movie: returnedDetail)
        }
    }
    
    func getVideo(id: Int) {
        service.downloadVideo(url: APIURLs.getVideoUrl(id: id)) { [weak self] returnedVideoUrls in
            guard let self = self else { return }
            guard let returnedVideoUrls = returnedVideoUrls else { return }
            for url in returnedVideoUrls {
                print(url._key)
                if url._key != "" {
                    videoUrl = url._key
                    return
                }
            }
            
        }
    }
}
