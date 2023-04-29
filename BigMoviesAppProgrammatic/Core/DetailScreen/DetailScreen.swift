//
//  DetailScreen.swift
//  BigMoviesAppProgrammatic
//
//  Created by Fatih Özen on 22.03.2023.
//

import UIKit
import AVKit
import AVFoundation
import YouTubeiOSPlayerHelper

protocol DetailScreenProtocol: AnyObject {
    
    func configureVC()
    func configureInfoView()
    func configureVideo()
    func configureCast()
    func configureSimilarMovies()
    func getMovie()
    func getCast()
    func reloadCollectionView()
    func reloadCastCollectionView()
    func navigateToDetail(movie: MovieResult)
}

final class DetailScreen: UIViewController, YTPlayerViewDelegate {

    private var movie: MovieResult!
    let viewModel = DetailViewModel()
    
    private var scrollView: UIScrollView!
    private var stackView: UIStackView!
    
    private var similarCollectionView: UICollectionView!
    private var castCollectionView: UICollectionView!
    private var infoView: DetailInfoView!
    
    private var playerView: VideoPlayerView!
    
    init(movie: MovieResult) {
        viewModel.getVideo(id: movie._id)
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.view = self
        viewModel.viewDidload()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if let playerView = playerView {
            playerView.playVideo()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        playerView = nil
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
           playerView.playVideo() 
    }
    
}

extension DetailScreen: DetailScreenProtocol {
    func configureVC() {
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
        title = movie._title
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        scrollView.pinToEdgeOfView(view: view)
        
        stackView = UIStackView()
        scrollView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.pinToEdgeOfView(view: scrollView)
        
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    func navigateToDetail(movie: MovieResult) {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(DetailScreen(movie: movie), animated: true)
        }
    }
    
    func getMovie() {
        viewModel.getSimilarMovies(url: APIURLs.getSimilarMovies(id: movie._id, page: viewModel.page))
    }
    
    func getCast() {
        viewModel.getCast(url: APIURLs.getCast(id: movie._id))
    }
    
    func reloadCollectionView() {
        similarCollectionView.reloadOnMainThread()
    }
    func reloadCastCollectionView() {
        castCollectionView.reloadOnMainThread()
    }
    
    func configureInfoView() {
        infoView = DetailInfoView(frame: .zero, movie: movie)
        stackView.addArrangedSubview(infoView)
        
        NSLayoutConstraint.activate([
            infoView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            infoView.heightAnchor.constraint(equalToConstant: infoView.viewHeight)
        ])
        
    }
    
    func configureVideo() {
        playerView = VideoPlayerView(frame: .zero, videoUrl: viewModel.videoUrl) // video url gelecek
        stackView.addArrangedSubview(playerView)
        
        playerView.delegate = self
        
        NSLayoutConstraint.activate([
            playerView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            playerView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func configureCast() {
        let title = UILabel(frame: .zero)
        stackView.addArrangedSubview(title)
        
        title.text = "Cast"
        title.font = .boldSystemFont(ofSize: 24)
        
        castCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createCollectionFlowLayout(kategori: "cast"))
        stackView.addArrangedSubview(castCollectionView)
        
        castCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        castCollectionView.register(CastCell.self, forCellWithReuseIdentifier: CastCell.reuseID)
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        castCollectionView.showsHorizontalScrollIndicator = false
        
        let collectionWidth = CGFloat.dWidth * 0.45
        
        NSLayoutConstraint.activate([
            castCollectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            castCollectionView.heightAnchor.constraint(equalToConstant: collectionWidth * 1.5)
        ])
    }
    
    func configureSimilarMovies() {
        let title = UILabel(frame: .zero)
        stackView.addArrangedSubview(title)
        
        title.text = "Similar Movies"
        title.font = .boldSystemFont(ofSize: 24)
        
        similarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createCollectionFlowLayout())
        stackView.addArrangedSubview(similarCollectionView)
        
        similarCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        similarCollectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseID)
        similarCollectionView.delegate = self
        similarCollectionView.dataSource = self
        similarCollectionView.showsHorizontalScrollIndicator = false
        
        let collectionWidth = CGFloat.dWidth * 0.5
        
        NSLayoutConstraint.activate([
            similarCollectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            similarCollectionView.heightAnchor.constraint(equalToConstant: collectionWidth * 1.5)
        ])
        
    }
    
}

extension DetailScreen: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == similarCollectionView {
            return viewModel.moviesList.count
        }
        return viewModel.castList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == similarCollectionView {
            
            let cell = similarCollectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseID, for: indexPath) as! MovieCell
            
            cell.setCell(movie: viewModel.moviesList[indexPath.item])
            return cell
        }
        
        let cell = castCollectionView.dequeueReusableCell(withReuseIdentifier: CastCell.reuseID, for: indexPath) as! CastCell
        
        cell.setCell(cast: viewModel.castList[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == similarCollectionView {
            viewModel.getDetail(id: viewModel.moviesList[indexPath.item]._id)
        }
    }
    
}

extension DetailScreen {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == similarCollectionView {
            
            let offsetX = scrollView.contentOffset.x
            let contentWidth = scrollView.contentSize.width
            let width = scrollView.frame.size.width
            
            guard offsetX != 0 else { return }
            if offsetX >= contentWidth - (width * 2) && viewModel.shouldMoreData{
                viewModel.getSimilarMovies(url: APIURLs.getSimilarMovies(id: movie._id, page: viewModel.page))
            }
        }
    }
}

