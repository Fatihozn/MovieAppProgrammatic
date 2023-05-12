//
//  HomeViewModel.swift
//  BigMoviesAppProgrammatic
//
//  Created by Fatih Özen on 21.03.2023.
//

import Foundation

protocol HomeViewModelProtocol {
    var view: HomeScreenProtocol? { get set }
    
    func viewDidLoad()
    func getMovies(url: String, list: String)
    func getDetail(id: Int)
    func configureMovies()
    func viewWillAppear()
}

final class HomeViewModel {
    
    weak var view: HomeScreenProtocol?
    private var service = MovieService()
    
    var popularList = [MovieResult]()
    var nowPlayingList = [MovieResult]()
    var upcomingList = [MovieResult]()
    var topRatedList = [MovieResult]()
    
    var popularPage = 1
    var nowPlayingPage = 1
    var upcomingPage = 1
    var topRatedPage = 1
    
    
    
    var shouldMoreData = true
    
}

extension HomeViewModel: HomeViewModelProtocol {
    
    func viewDidLoad() {
        view?.configureVC()
        view?.configurePopularCollection()
        view?.configureNowPlayingCollection()
        view?.configureUpcomingCollection()
        view?.configureTopRatedCollection()
        configureMovies()
    }
    
    func viewWillAppear() {
        view?.hideNavigationBar()
    }
    
    func getMovies(url: String, list: String) {
        shouldMoreData = false
        service.downloadMovies(url: url) { [weak self] returned in
            guard let self = self else { return }
            guard let returned = returned else { return }
            
            if list == "popular" {
                self.popularList.append(contentsOf: returned)
                self.popularPage += 1
                self.view?.reloadCollection(name: list)
            }
            else if list == "now" {
                self.nowPlayingList.append(contentsOf: returned)
                self.nowPlayingPage += 1
                self.view?.reloadCollection(name: list)
            }
            else if list == "upcoming" {
                self.upcomingList.append(contentsOf: returned)
                self.upcomingPage += 1
                self.view?.reloadCollection(name: list)
            }
            else if list == "top" {
                self.topRatedList.append(contentsOf: returned)
                self.topRatedPage += 1
                self.view?.reloadCollection(name: list)
            }
            self.shouldMoreData = true
        }
    }
    func getDetail(id: Int) {
        var url = ""
        if view?.ApiControl == "tv" {
             url = APIURLs.getDetailTV(id: id)
        } else {
             url = APIURLs.getDetail(id: id)
        }
        service.downloadDetail(url: url,id: id) { [weak self] (returnedDetail, data) in
            guard let self = self else { return }
            guard let returnedDetail = returnedDetail else { return }
            
            self.view?.navigateToDetail(movie: returnedDetail, data: data)
        }
    }
    
    func configureMovies() {
        if view?.ApiControl == "tv" {
            getMovies(url: APIURLs.getPopularTV(page: popularPage), list: "popular")
            getMovies(url: APIURLs.getNowPlayingTV(page: nowPlayingPage), list: "now")
            getMovies(url: APIURLs.getUpcommingTV(page: upcomingPage), list: "upcoming")
            getMovies(url: APIURLs.getTopRatedTV(page: topRatedPage), list: "top")
        } else {
            getMovies(url: APIURLs.getPopularMovies(page: popularPage), list: "popular")
            getMovies(url: APIURLs.getNowPlayingMovies(page: nowPlayingPage), list: "now")
            getMovies(url: APIURLs.getUpcomingMovies(page: upcomingPage), list: "upcoming")
            getMovies(url: APIURLs.getTopRatedMovies(page: topRatedPage), list: "top")
        }
    }
    
}
