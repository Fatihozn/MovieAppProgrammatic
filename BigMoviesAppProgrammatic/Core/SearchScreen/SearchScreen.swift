//
//  SearchScreen.swift
//  BigMoviesAppProgrammatic
//
//  Created by Fatih Özen on 27.04.2023.
//

import UIKit

protocol SearchScreenProtocol: AnyObject {
    
    func configVC()
    func configSearchBar()
    func configCollectionView()
    func reloadCollectionView()
    func navigateToDetail(movie: MovieResult, data: Data, control: String)
}

final class SearchScreen: UIViewController {
    
    let viewModel = SearchViewModel()
    
    private var searchCollectionView: UICollectionView!
    private var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.view = self
        viewModel.viewDidLoad()
        
    }
    
    func reloadCollectionView() {
        searchCollectionView.reloadOnMainThread()
    }
    
    func navigateToDetail(movie: MovieResult, data: Data, control: String) {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(DetailScreen(movie: movie, ApiControl: control, data: data), animated: true)
        }
    }

}

extension SearchScreen: SearchScreenProtocol {
    
    func configVC() {
        view.backgroundColor = .systemBackground
    }
    
    func configSearchBar() {
        searchBar = UISearchBar(frame: .zero)
        view.addSubview(searchBar)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.delegate = self
        
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func configCollectionView() {
        searchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createSearchCollectionFlowLayout())
        view.addSubview(searchCollectionView)
        
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
        
        searchCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        searchCollectionView.register(SearchCell.self, forCellWithReuseIdentifier: SearchCell.reuseID)
        
        NSLayoutConstraint.activate([
            searchCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            searchCollectionView.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor),
            searchCollectionView.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor),
            searchCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension SearchScreen: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.searchList.isEmpty {
          return viewModel.trendingList.count
        }
        return viewModel.searchList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = searchCollectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.reuseID, for: indexPath) as! SearchCell
        
        var movie: MovieResult!
        if viewModel.searchList.isEmpty {
            movie = viewModel.trendingList[indexPath.item]
        } else {
            movie = viewModel.searchList[indexPath.item]
        }
        
        cell.setCell(movie: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var movie: MovieResult!
        if viewModel.searchList.isEmpty {
            movie = viewModel.trendingList[indexPath.item]
        } else {
            movie = viewModel.searchList[indexPath.item]
        }
        viewModel.getDetail(id: movie._id, control: movie._mediaType)
    }

}

extension SearchScreen: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.getSearch(text: searchText)
    }
}
