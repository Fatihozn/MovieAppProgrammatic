//
//  CastDetailScreenViewModel.swift
//  BigMoviesAppProgrammatic
//
//  Created by Fatih Özen on 3.05.2023.
//

import Foundation

protocol CastDetailViewModelProtocol {
    var view: CastDetailScreenProtocol? { get set }
    
    func viewDidLoad()
}

final class CastDetailViewModel {
    weak var view: CastDetailScreenProtocol?
    private let service = MovieService()
    var tvCreditsList = [MovieResult]()
    var moviesCreditsList = [MovieResult]()
}

extension CastDetailViewModel: CastDetailViewModelProtocol {
    
    func viewDidLoad() {
        view?.configVC()
        view?.configInfoView()
    }
    
    func getTVCredits(id: Int) {
        service.donwloadCastMovie(url: APIURLs.getTVCredits(id: id)) { [weak self] returnedList in
            guard let self = self else { return }
            guard let returnedList = returnedList else { return }
            
            DispatchQueue.main.async {
                self.view?.configShowsCollectionView()
            }
            
            tvCreditsList = returnedList
            view?.reloadTvCollectionView()
        }
    }
    
    func getMovieCredits(id: Int) {
        service.donwloadCastMovie(url: APIURLs.getMovieCredits(id: id)) { [weak self] returnedList in
            guard let self = self else { return }
            guard let returnedList = returnedList else { return }
            
            DispatchQueue.main.async {
                self.view?.configMoviesCollectionView()
            }
            
            moviesCreditsList = returnedList
            view?.reloadMovieCollectionView()
        }
    }
    
    func getDetail(id: Int, control: String) {
        var url = ""
        if control == "tv" {
            url = APIURLs.getDetailTV(id: id)
        } else {
            url = APIURLs.getDetail(id: id)
        }
        service.downloadDetail(url: url, id: id) { [weak self] (returnedDetail, data) in
            guard let self = self else { return }
            guard let returnedDetail = returnedDetail else { return }
            
            self.view?.navigateToDetail(movie: returnedDetail, control: control, data: data)
        }
    }
}
