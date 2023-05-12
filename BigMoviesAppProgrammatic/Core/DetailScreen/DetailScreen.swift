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
    var ApiControl: String { get set }
   
    func configureVC()
    func configFavButton()
    func configureInfoView()
    func configureVideo()
    func configureCast()
    func configureSimilarMovies()
    func getMovie()
    func getCast()
    func reloadCollectionView()
    func reloadCastCollectionView()
    func navigateToDetail(movie: MovieResult, data: Data)
    func navigateToCastDetail(cast: CastResult)
}

final class DetailScreen: UIViewController, YTPlayerViewDelegate {

    var ApiControl: String
    private var movie: MovieResult
    private var data: Data
    let viewModel = DetailViewModel()
    
    private var scrollView: UIScrollView!
    private var stackView: UIStackView!
    
    private var similarCollectionView: UICollectionView?
    private var castCollectionView: UICollectionView?
    private var infoView: DetailInfoView!
    private var favButton: UIBarButtonItem?
    
    private var playerView: VideoPlayerView!
    private let userDefault = UserDefaults.standard
    private var favList = [Data]()
    private var favListControl = [String]()
    
    init(movie: MovieResult, ApiControl: String, data: Data) {
        viewModel.getVideo(id: movie._id)
        self.movie = movie
        self.ApiControl = ApiControl
        self.data = data
        super.init(nibName: nil, bundle: nil)
        favList = userDefault.array(forKey: "favList") as? [Data] ?? [Data]()
        favListControl = userDefault.array(forKey: "control") as? [String] ?? [String]()
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
        favList = userDefault.array(forKey: "favList") as? [Data] ?? [Data]()
        favListControl = userDefault.array(forKey: "control") as? [String] ?? [String]()
        viewModel.viewWillApear()
        if let playerView = playerView {
            playerView.playVideo()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        playerView = nil
    }
}

extension DetailScreen: DetailScreenProtocol {
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
        if ApiControl == "tv" {
            title = movie._name
        } else {
            title = movie._title
        }
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        scrollView.pinToEdgeOfView(view: view)
        
        stackView = UIStackView()
        scrollView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.pinToEdgeOfView(view: scrollView)
        
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    func configFavButton() {
        
        if favList.contains(data) {
            favButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteFavButton))
            navigationItem.rightBarButtonItem = favButton
        } else {
            favButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(favButtonClicked))
            navigationItem.rightBarButtonItem = favButton
        }
        
    }
    
    @objc func favButtonClicked() {
        favList.append(data)
        favListControl.append(ApiControl)
        //favList.removeAll()
        //favListControl.removeAll()
        print(favList)
        print(favListControl)
        userDefault.set(favList, forKey: "favList")
        userDefault.set(favListControl, forKey: "control")
        
        favButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteFavButton))
        navigationItem.rightBarButtonItem = favButton
    }
    
    @objc func deleteFavButton() {
        if let index = favList.firstIndex(of: data) {
            favList.remove(at: index)
            favListControl.remove(at: index)
            print(favList)
            print(favListControl)
            userDefault.set(favList, forKey: "favList")
            userDefault.set(favListControl, forKey: "control")
        }
        favButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(favButtonClicked))
        navigationItem.rightBarButtonItem = favButton
    }
    
    func navigateToDetail(movie: MovieResult, data: Data) {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(DetailScreen(movie: movie, ApiControl: self.ApiControl, data: data), animated: true)
        }
    }
    
    func navigateToCastDetail(cast: CastResult) {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(CastDetailScreen(cast: cast), animated: true)
        }
    }
    
    func getMovie() {
        var url = ""
        if ApiControl == "tv" {
            url = APIURLs.getSimilarTV(id: movie._id, page: 1)
        } else {
            url = APIURLs.getSimilarMovies(id: movie._id, page: 1)
        }
        viewModel.getSimilar(url: url)
    }
    
    func getCast() {
        var url = ""
        if ApiControl == "tv" {
            url = APIURLs.getCastTV(id: movie._id)
        } else {
            url = APIURLs.getCast(id: movie._id)
        }
        viewModel.getCast(url: url)
    }
    
    func reloadCollectionView() {
        similarCollectionView?.reloadOnMainThread()
    }
    func reloadCastCollectionView() {
        castCollectionView?.reloadOnMainThread()
    }
    
    func configureInfoView() {
        infoView = DetailInfoView(frame: .zero, movie: movie, ApiControl: ApiControl)
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
        stackView.addArrangedSubview(castCollectionView!)
        
        castCollectionView!.translatesAutoresizingMaskIntoConstraints = false
        
        castCollectionView!.register(CastCell.self, forCellWithReuseIdentifier: CastCell.reuseID)
        castCollectionView!.delegate = self
        castCollectionView!.dataSource = self
        castCollectionView!.showsHorizontalScrollIndicator = false
        
        let collectionWidth = CGFloat.dWidth * 0.45
        
        NSLayoutConstraint.activate([
            castCollectionView!.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            castCollectionView!.heightAnchor.constraint(equalToConstant: collectionWidth * 1.5)
        ])
    }
    
    func configureSimilarMovies() {
        let title = UILabel(frame: .zero)
        stackView.addArrangedSubview(title)
        
        if ApiControl == "tv" {
            title.text = "Similar Shows"
        } else {
            title.text = "Similar Movies"
        }
        title.font = .boldSystemFont(ofSize: 24)
    
        similarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createCollectionFlowLayout())
        stackView.addArrangedSubview(similarCollectionView!)
        
        similarCollectionView!.translatesAutoresizingMaskIntoConstraints = false
        
        similarCollectionView!.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseID)
        similarCollectionView!.delegate = self
        similarCollectionView!.dataSource = self
        similarCollectionView!.showsHorizontalScrollIndicator = false
        
        let collectionWidth = CGFloat.dWidth * 0.5
        
        NSLayoutConstraint.activate([
            similarCollectionView!.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            similarCollectionView!.heightAnchor.constraint(equalToConstant: collectionWidth * 1.5)
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
            
            let cell = similarCollectionView?.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseID, for: indexPath) as! MovieCell
            
            cell.setCell(movie: viewModel.moviesList[indexPath.item])
            return cell
        }
        
        let cell = castCollectionView?.dequeueReusableCell(withReuseIdentifier: CastCell.reuseID, for: indexPath) as! CastCell
        
        cell.setCell(cast: viewModel.castList[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == similarCollectionView {
            viewModel.getDetail(id: viewModel.moviesList[indexPath.item]._id)
        }
        
        if collectionView == castCollectionView {
            viewModel.getCastDetail(id: viewModel.castList[indexPath.item]._id)
        }
    }
    
}

