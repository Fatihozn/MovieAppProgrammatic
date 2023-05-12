//
//  FavoriteScreen.swift
//  BigMoviesAppProgrammatic
//
//  Created by Fatih Özen on 2.05.2023.
//

import UIKit

protocol FavoriteScreenProtocol: AnyObject {
    
    func configVC()
    func configCollectionView()
    func reloadCollectionView()
    func navigateToDetail(movie: MovieResult, data: Data, control: String)
}

final class FavoriteScreen: UIViewController {
    
    private let viewModel = FavoriteScreenViewModel()

    private var favCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.view = self
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.viewWillApear()
    }
    
    func reloadCollectionView() {
        favCollectionView.reloadOnMainThread()
    }
    
    func navigateToDetail(movie: MovieResult, data: Data, control: String) {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(DetailScreen(movie: movie, ApiControl: control, data: data), animated: true)
        }
    }

}

extension FavoriteScreen: FavoriteScreenProtocol, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func configVC() {
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "FAVORITES"
        //navigationItem.largeTitleDisplayMode = .always
    }
    
    func configCollectionView() {
        favCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createSearchCollectionFlowLayout())
        view.addSubview(favCollectionView)
        
        favCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        favCollectionView.dataSource = self
        favCollectionView.delegate = self
        favCollectionView.showsVerticalScrollIndicator = false
        
        favCollectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseID)
        favCollectionView.pinToEdgeOfView(view: view)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.favList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favCollectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseID, for: indexPath) as! MovieCell
        
        let favMovie = viewModel.favList[indexPath.item]
        cell.setCell(movie: favMovie)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.favList[indexPath.item]
        let control = viewModel.controlList[indexPath.item]
        viewModel.getDetail(id: movie._id, control: control)
    }
}
