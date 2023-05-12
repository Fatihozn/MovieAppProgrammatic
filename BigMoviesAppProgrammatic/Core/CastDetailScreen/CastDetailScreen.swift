//
//  CastDetailScreen.swift
//  BigMoviesAppProgrammatic
//
//  Created by Fatih Özen on 3.05.2023.
//

import UIKit

protocol CastDetailScreenProtocol: AnyObject {
    
    func configVC()
    func configInfoView()
    func configMoviesCollectionView()
    func configShowsCollectionView()
    func reloadMovieCollectionView()
    func reloadTvCollectionView()
    func navigateToDetail(movie: MovieResult, control: String, data: Data)
}

final class CastDetailScreen: UIViewController {

    private var cast: CastResult
    private let viewModel = CastDetailViewModel()
    
    private var scrollView: UIScrollView!
    private var stackView: UIStackView!
    private var infoView: DetailInfoView!
    private var movieCollectionView: UICollectionView?
    private var tvCollectionView: UICollectionView?
    
    init(cast: CastResult){
        self.cast = cast
        super.init(nibName: nil, bundle: nil)
        viewModel.getMovieCredits(id: cast._id)
        viewModel.getTVCredits(id: cast._id)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.view = self
        viewModel.viewDidLoad()
    }
    
    func reloadMovieCollectionView() {
        movieCollectionView?.reloadOnMainThread()
    }
    func reloadTvCollectionView() {
        tvCollectionView?.reloadOnMainThread()
    }
    
    func navigateToDetail(movie: MovieResult, control: String, data: Data) {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(DetailScreen(movie: movie, ApiControl: control, data: data), animated: true)
        }
    }
    
}

extension CastDetailScreen: CastDetailScreenProtocol {
    func configVC() {
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
        
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        scrollView.pinToEdgeOfView(view: view)
        
        stackView = UIStackView()
        scrollView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.pinToEdgeOfView(view: scrollView)
        
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    func configInfoView() {
        infoView = DetailInfoView(frame: .zero, cast: cast, ApiControl: "")
        stackView.addArrangedSubview(infoView)
        
        NSLayoutConstraint.activate([
            infoView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            infoView.heightAnchor.constraint(equalToConstant: infoView.viewHeight)
        ])
    }
    
    func configMoviesCollectionView() {
        let title = UILabel(frame: .zero)
        stackView.addArrangedSubview(title)
        
        title.text = "Movies"
        title.font = .boldSystemFont(ofSize: 24)
    
        movieCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createCollectionFlowLayout())
        stackView.addArrangedSubview(movieCollectionView!)
        
        movieCollectionView!.translatesAutoresizingMaskIntoConstraints = false
        
        movieCollectionView!.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseID)
        movieCollectionView!.delegate = self
        movieCollectionView!.dataSource = self
        movieCollectionView!.showsHorizontalScrollIndicator = false
        
        let collectionWidth = CGFloat.dWidth * 0.5
        
        NSLayoutConstraint.activate([
            movieCollectionView!.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            movieCollectionView!.heightAnchor.constraint(equalToConstant: collectionWidth * 1.5)
        ])
    }
    
    func configShowsCollectionView() {
        let title = UILabel(frame: .zero)
        stackView.addArrangedSubview(title)
        
        title.text = "Shows"
        title.font = .boldSystemFont(ofSize: 24)
    
        tvCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createCollectionFlowLayout())
        stackView.addArrangedSubview(tvCollectionView!)
        
        tvCollectionView!.translatesAutoresizingMaskIntoConstraints = false
        
        tvCollectionView!.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseID)
        tvCollectionView!.delegate = self
        tvCollectionView!.dataSource = self
        tvCollectionView!.showsHorizontalScrollIndicator = false
        
        let collectionWidth = CGFloat.dWidth * 0.5
        
        NSLayoutConstraint.activate([
            tvCollectionView!.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            tvCollectionView!.heightAnchor.constraint(equalToConstant: collectionWidth * 1.5)
        ])
    }
    
    
}
extension CastDetailScreen: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == movieCollectionView {
            return viewModel.moviesCreditsList.count
        }
        return viewModel.tvCreditsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == tvCollectionView {
            let cell = tvCollectionView?.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseID, for: indexPath) as! MovieCell
            
            cell.setCell(movie: viewModel.tvCreditsList[indexPath.item])
            
            return cell
        }
        let cell = movieCollectionView!.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseID, for: indexPath) as! MovieCell
        
        cell.setCell(movie: viewModel.moviesCreditsList[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var movie = viewModel.moviesCreditsList[indexPath.item]
        var control = "movie"
        
        if collectionView == tvCollectionView {
            movie = viewModel.tvCreditsList[indexPath.item]
            control = "tv"
        }
        
        viewModel.getDetail(id: movie._id, control: control)
    }
}
