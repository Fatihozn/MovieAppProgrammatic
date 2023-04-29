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
    
}

extension SearchViewModel: SearchViewModelProtocol {
    
    func viewDidLoad() {
        view?.configVC()
    }
    
}
