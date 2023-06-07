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
    func getSimilar(url: String)
}

final class DetailViewModel {
    
    weak var view: DetailScreenProtocol?
    private let service = MovieService()
    var moviesList = [MovieResult]()
    var castList = [CastResult]()
    var videoUrl = ""
}

extension DetailViewModel: DetailViewModelProtocol {
    
    func viewDidload() {
        view?.configureVC()
        view?.configureInfoView()
        view?.getCast()
    }
    
    func viewWillApear() {
        view?.configFavButton()
    }
    
    func getSimilar(url: String) {
        service.downloadMovies(url: url) { [weak self] returnedList in
            guard let self = self else { return }
            guard let returnedList = returnedList else { return }
            
            if returnedList.count != 0 {
                DispatchQueue.main.async {
                    self.view?.configureSimilarMovies()
                }
                
                self.moviesList.append(contentsOf: returnedList)
                self.view?.reloadCollectionView()
            }
        }
    }
    
    func getCast(url: String) {
        service.downloadCast(url: url) { [weak self] returnedCast in
            guard let self = self else { return }
            guard let returnedCast = returnedCast else { return }
            view?.getMovie()
            if returnedCast.count != 0 {
                DispatchQueue.main.async {
                    self.view?.configureCast()
                }
                
                var slicedList = returnedCast
                if returnedCast.count > 10 {
                    slicedList = Array(returnedCast[0..<10])
                }
                
                self.castList.append(contentsOf: slicedList)
                self.view?.reloadCastCollectionView()
            }
        }
    }
    
    func getDetail(id: Int) {
        var url = ""
        if view?.ApiControl == "tv" {
            url = APIURLs.getDetailTV(id: id)
        } else {
            url = APIURLs.getDetail(id: id)
        }
        service.downloadDetail(url: url, id: id) { [weak self] (returnedDetail, data) in
            guard let self = self else { return }
            guard let returnedDetail = returnedDetail else { return }
            
            self.view?.navigateToDetail(movie: returnedDetail, data: data)
        }
    }
    
    func getVideo(id: Int) {
        var url = ""
        if view?.ApiControl == "tv" {
            url = APIURLs.getVideoUrlTV(id: id)
        } else {
            url = APIURLs.getVideoUrl(id: id)
        }
        service.downloadVideo(url: url) { [weak self] returnedVideoUrls in
            guard let self = self else { return }
            guard let returnedVideoUrls = returnedVideoUrls else {
                videoUrl = ""
                return
            }
            
            if returnedVideoUrls.count > 0 {
                DispatchQueue.main.async {
                    self.view?.configureVideo()
                }
                
                for url in returnedVideoUrls {
                    if url._key != "" {
                        videoUrl = url._key
                        return
                    }
                }
                
            }
        }
    }
    
    func getCastDetail(id: Int) {
        service.downloadCastDetail(url: APIURLs.getCastDetail(id: id)) { [weak self] returnedCast in
            guard let self = self else { return }
            guard let returnedCast = returnedCast else { return }
            
            view?.navigateToCastDetail(cast: returnedCast)
        }
    }
}
