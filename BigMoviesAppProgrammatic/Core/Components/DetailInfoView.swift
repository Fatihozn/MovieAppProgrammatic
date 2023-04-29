//
//  DetailInfoView.swift
//  BigMoviesAppProgrammatic
//
//  Created by Fatih Özen on 24.03.2023.
//

import UIKit

class DetailInfoView: UIView {

    private let movie: MovieResult
    private var posterImageView: PosterImageView!
    private var titleLabel: UILabel!
    private var dateLabel: UILabel!
    private var genresLabel: UILabel!
    private var avarageLabel: UILabel!
    private var overviewLabel: UILabel!
    
    var viewHeight: CGFloat = 0.0

    init(frame: CGRect, movie: MovieResult) {
        self.movie = movie
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
         configurePosterImageView()
         configureTitleLabel()
         configureDateLabel()
         configureGenresLabel()
         configureAvarageLabel()
         configureOverviewLabel()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurePosterImageView() {
        posterImageView = PosterImageView(frame: .zero)
        self.addSubview(posterImageView)
        
        posterImageView.downloadImage(posterPath: movie._posterPath)
        
        posterImageView.layer.cornerRadius = 16
        posterImageView.clipsToBounds = true
        let imageWidth = CGFloat.dWidth * 0.4
        
        viewHeight += imageWidth * 1.5
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            posterImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            posterImageView.widthAnchor.constraint(equalToConstant: imageWidth),
            posterImageView.heightAnchor.constraint(equalToConstant: imageWidth * 1.5)
        ])
    }
    
    func configureTitleLabel() {
        titleLabel = UILabel(frame: .zero)
        self.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = movie._title
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 2
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20)
        ])
        
    }
    
    func configureDateLabel() {
        dateLabel = UILabel(frame: .zero)
        self.addSubview(dateLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.text = "📆  " + movie._releaseDate
        dateLabel.font = .systemFont(ofSize: 20)
        dateLabel.textColor = .secondaryLabel
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }
    
    func configureGenresLabel() {
        genresLabel = UILabel(frame: .zero)
        self.addSubview(genresLabel)
        
        genresLabel.translatesAutoresizingMaskIntoConstraints = false
        
        var text = "🎬 "
        
        for item in movie._genres {
            text += " " + item._name + ","
        }
        text.removeLast()
        
        genresLabel.text = text
        genresLabel.font = .systemFont(ofSize: 20)
        genresLabel.textColor = .secondaryLabel
        genresLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            genresLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            genresLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            genresLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor)
        ])
    }
    
    func configureAvarageLabel() {
        avarageLabel = UILabel(frame: .zero)
        self.addSubview(avarageLabel)
        
        avarageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        avarageLabel.text = "⭐️  " + String(movie._voteAverage)
        avarageLabel.font = .systemFont(ofSize: 20)
        avarageLabel.textColor = .secondaryLabel
        
        NSLayoutConstraint.activate([
            avarageLabel.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 10),
            avarageLabel.leadingAnchor.constraint(equalTo: genresLabel.leadingAnchor),
            avarageLabel.trailingAnchor.constraint(equalTo: genresLabel.trailingAnchor)
        ])
    }
    
    func configureOverviewLabel() {
        overviewLabel = UILabel(frame: .zero)
        self.addSubview(overviewLabel)
        
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        overviewLabel.text = movie._overview
        overviewLabel.font = .systemFont(ofSize: 16)
        overviewLabel.numberOfLines = 0
        
        //MARK: - dinamik label boyutu alma
        let constraint = CGSize(width: .dWidth - 20 , height: .zero)
        // Label için minimum boyutu hesapla
        let labelSize = overviewLabel.sizeThatFits(constraint)
        
        viewHeight += labelSize.height + 30
        
        NSLayoutConstraint.activate([
            overviewLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 10),
            overviewLabel.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(equalTo: avarageLabel.trailingAnchor)
        ])
    }
    

}
