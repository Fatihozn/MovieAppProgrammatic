//
//  SearchViewModel.swift
//  BigMoviesAppProgrammatic
//
//  Created by Fatih Özen on 27.04.2023.
//

import Foundation

protocol SearchViewModelProtocol {
    var view: SearchScreenProtocol? { get set }
    
    func viewDidLoad()
}

final class SearchViewModel {
    weak var view: SearchScreenProtocol?
    
    private let service = MovieService()
    var trendingList = [MovieResult]()
    var searchList = [MovieResult]()
}

extension SearchViewModel: SearchViewModelProtocol {
    
    func viewDidLoad() {
        view?.configVC()
        view?.configSearchBar()
        view?.configCollectionView()
        getTrending()
    }
    
    func getTrending() {
        service.downloadMovies(url: APIURLs.getTrending()) { [weak self] returnedList in
            guard let self = self else { return }
            guard let returnedList = returnedList else { return }
            
            trendingList = returnedList
            view?.reloadCollectionView()
        }
    }
    
    func getSearch(text: String) {
        if text == "" {
            searchList.removeAll()
            view?.reloadCollectionView()
        } else {
            service.downloadMovies(url: APIURLs.getSearch(text: text)) { [ weak self ] returnedList in
                guard let self = self else { return }
                guard let returnedList = returnedList else { return }
                
                searchList = returnedList
                view?.reloadCollectionView()
            }
        }
        
    }
    
    func getDetail(id: Int, control: String) {
        var url = ""
        if control == "tv" {
             url = APIURLs.getDetailTV(id: id)
        } else {
             url = APIURLs.getDetail(id: id)
        }
        service.downloadDetail(url: url,id: id) { [weak self] (returnedDetail, data) in
            guard let self = self else { return }
            guard let returnedDetail = returnedDetail else { return }
            
            self.view?.navigateToDetail(movie: returnedDetail, data: data, control: control)
        }
    }
    
}
