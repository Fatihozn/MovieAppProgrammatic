//
//  SearchScreen.swift
//  BigMoviesAppProgrammatic
//
//  Created by Fatih Özen on 27.04.2023.
//

import UIKit

protocol SearchScreenProtocol: AnyObject {
    
    func configVC()
}

final class SearchScreen: UIViewController {
    
    let viewModel = SearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.view = self
        viewModel.viewDidLoad()
        
    }

}

extension SearchScreen: SearchScreenProtocol {
    
    func configVC() {
        view.backgroundColor = .systemBackground
    }
}
