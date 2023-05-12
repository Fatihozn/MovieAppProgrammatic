//
//  HomeScreen.swift
//  BigMoviesAppProgrammatic
//
//  Created by Fatih Özen on 19.03.2023.
//

import UIKit

protocol HomeScreenProtocol: AnyObject{
    var ApiControl: String { get set }
    
    func configureVC()
    func configurePopularCollection()
    func configureNowPlayingCollection()
    func configureUpcomingCollection()
    func configureTopRatedCollection()
    func reloadCollection(name: String)
    func hideNavigationBar()
    func navigateToDetail(movie: MovieResult, data: Data)
}

final class HomeScreen: UIViewController {

    var ApiControl: String
    private var viewModel = HomeViewModel()
    
    private var scrollView: UIScrollView!
    private var stackView: UIStackView!
    
    private var popularCollection: UICollectionView!
    private var nowPlayingCollection: UICollectionView!
    private var upcomingCollection: UICollectionView!
    private var topRatedCollection: UICollectionView!
    
    init(ApiControl: String) {
        self.ApiControl = ApiControl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.view = self
        viewModel.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.viewWillAppear()
    }
    
}

extension HomeScreen: HomeScreenProtocol {
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        scrollView.pinToEdgeOfView(view: view)
        
        stackView = UIStackView()
        scrollView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.pinToEdgeOfView(view: scrollView)
        
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
    }
    
    func hideNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    func reloadCollection(name: String) {
        switch name {
        case "popular":
            popularCollection.reloadOnMainThread()
        case "now":
            nowPlayingCollection.reloadOnMainThread()
        case "upcoming":
            upcomingCollection.reloadOnMainThread()
        case "top":
            topRatedCollection.reloadOnMainThread()
        default:
            break
        }
       
    }
    
    func navigateToDetail(movie: MovieResult, data: Data) {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(DetailScreen(movie: movie, ApiControl: self.ApiControl, data: data), animated: true)
        }
    }

}
// MARK: Collection Views Functions

extension HomeScreen: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == nowPlayingCollection {
            return viewModel.nowPlayingList.count
        }
        else if collectionView == upcomingCollection {
            return viewModel.upcomingList.count
        }
        else if collectionView == topRatedCollection {
            return viewModel.topRatedList.count
        }
        
        return viewModel.popularList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = popularCollection.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseID, for: indexPath) as! MovieCell
        
        if collectionView == nowPlayingCollection {
            let cell = nowPlayingCollection.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseID, for: indexPath) as! MovieCell
            cell.setCell(movie: viewModel.nowPlayingList[indexPath.item])
            return cell
        }
        if collectionView == upcomingCollection {
            let cell = upcomingCollection.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseID, for: indexPath) as! MovieCell
            cell.setCell(movie: viewModel.upcomingList[indexPath.item])
            return cell
        }
        if collectionView == topRatedCollection {
            let cell = topRatedCollection.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseID, for: indexPath) as! MovieCell
            cell.setCell(movie: viewModel.topRatedList[indexPath.item])
            return cell
        }
        
        cell.setCell(movie: viewModel.popularList[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == popularCollection {
            viewModel.getDetail(id: viewModel.popularList[indexPath.item]._id)
        }
        else if collectionView == nowPlayingCollection {
            viewModel.getDetail(id: viewModel.nowPlayingList[indexPath.item]._id)
        }
        else if collectionView == upcomingCollection {
            viewModel.getDetail(id: viewModel.upcomingList[indexPath.item]._id)
        }
        else if collectionView == topRatedCollection {
            viewModel.getDetail(id: viewModel.topRatedList[indexPath.item]._id)
        }
    }
    
}
// MARK: Pagination

extension HomeScreen {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetx = scrollView.contentOffset.x
        let contentWidth = scrollView.contentSize.width
        let width = scrollView.frame.size.width
        
        guard offsetx != 0 else { return }
       
        if offsetx >= contentWidth - (width * 2) && viewModel.shouldMoreData{
            if ApiControl == "tv" {
                if scrollView == popularCollection {
                    viewModel.getMovies(url: APIURLs.getPopularTV(page: viewModel.popularPage), list: "popular")
                }
                else if scrollView == nowPlayingCollection {
                    viewModel.getMovies(url: APIURLs.getNowPlayingTV(page: viewModel.nowPlayingPage), list: "now")
                }
                else if scrollView == upcomingCollection {
                    viewModel.getMovies(url: APIURLs.getUpcommingTV(page: viewModel.upcomingPage), list: "upcoming")
                }
                else if scrollView == topRatedCollection {
                    viewModel.getMovies(url: APIURLs.getTopRatedTV(page: viewModel.upcomingPage), list: "top")
                }
                
            } else {
                if scrollView == popularCollection {
                    viewModel.getMovies(url: APIURLs.getPopularMovies(page: viewModel.popularPage), list: "popular")
                }
                else if scrollView == nowPlayingCollection {
                    viewModel.getMovies(url: APIURLs.getNowPlayingMovies(page: viewModel.nowPlayingPage), list: "now")
                }
                else if scrollView == upcomingCollection {
                    viewModel.getMovies(url: APIURLs.getUpcomingMovies(page: viewModel.upcomingPage), list: "upcoming")
                }
                else if scrollView == topRatedCollection {
                    viewModel.getMovies(url: APIURLs.getTopRatedMovies(page: viewModel.upcomingPage), list: "top")
                }
            }
        }
    }
}
// MARK: Configure Collection Views

extension HomeScreen {
    func configurePopularCollection() {
        let title = UILabel(frame: .zero)
        stackView.addArrangedSubview(title)
        
        if ApiControl == "tv" {
            title.text = "Populer Shows"
        } else {
            title.text = "Populer Movies"
        }
        title.font = .boldSystemFont(ofSize: 24)
        
        
        popularCollection = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createCollectionFlowLayout())
        stackView.addArrangedSubview(popularCollection)
        
        popularCollection.translatesAutoresizingMaskIntoConstraints = false
        popularCollection.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseID)
        popularCollection.delegate = self
        popularCollection.dataSource = self
        popularCollection.showsHorizontalScrollIndicator = false
        
        let collectionWidth = CGFloat.dWidth * 0.5
        
        NSLayoutConstraint.activate([
            popularCollection.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            popularCollection.heightAnchor.constraint(equalToConstant: collectionWidth * 1.5)
        ])
    }
    
    func configureNowPlayingCollection() {
        let title = UILabel(frame: .zero)
        stackView.addArrangedSubview(title)
        
        title.text = "Now Playing"
        title.font = .boldSystemFont(ofSize: 24)
        
        nowPlayingCollection = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createCollectionFlowLayout())
        stackView.addArrangedSubview(nowPlayingCollection)
        
        
        nowPlayingCollection.translatesAutoresizingMaskIntoConstraints = false
        nowPlayingCollection.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseID)
        nowPlayingCollection.delegate = self
        nowPlayingCollection.dataSource = self
        nowPlayingCollection.showsHorizontalScrollIndicator = false
        
        let collectionWidth = CGFloat.dWidth * 0.5
        
        NSLayoutConstraint.activate([
            nowPlayingCollection.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            nowPlayingCollection.heightAnchor.constraint(equalToConstant: collectionWidth * 1.5)
        ])
        
    }
    
    func configureUpcomingCollection() {
        let title = UILabel(frame: .zero)
        stackView.addArrangedSubview(title)
        
        title.text = "Upcoming"
        title.font = .boldSystemFont(ofSize: 24)
        
        upcomingCollection = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createCollectionFlowLayout())
        stackView.addArrangedSubview(upcomingCollection)
        
        
        upcomingCollection.translatesAutoresizingMaskIntoConstraints = false
        upcomingCollection.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseID)
        upcomingCollection.delegate = self
        upcomingCollection.dataSource = self
        upcomingCollection.showsHorizontalScrollIndicator = false
        
        let collectionWidth = CGFloat.dWidth * 0.5
        
        NSLayoutConstraint.activate([
            upcomingCollection.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            upcomingCollection.heightAnchor.constraint(equalToConstant: collectionWidth * 1.5)
        ])
    }
    
    func configureTopRatedCollection() {
        let title = UILabel(frame: .zero)
        stackView.addArrangedSubview(title)
        
        title.text = "Top Rated"
        title.font = .boldSystemFont(ofSize: 24)
        
        topRatedCollection = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createCollectionFlowLayout())
        stackView.addArrangedSubview(topRatedCollection)
        
        
        topRatedCollection.translatesAutoresizingMaskIntoConstraints = false
        topRatedCollection.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseID)
        topRatedCollection.delegate = self
        topRatedCollection.dataSource = self
        topRatedCollection.showsHorizontalScrollIndicator = false
        
        let collectionWidth = CGFloat.dWidth * 0.5
        
        NSLayoutConstraint.activate([
            topRatedCollection.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            topRatedCollection.heightAnchor.constraint(equalToConstant: collectionWidth * 1.5)
        ])
    }
}
