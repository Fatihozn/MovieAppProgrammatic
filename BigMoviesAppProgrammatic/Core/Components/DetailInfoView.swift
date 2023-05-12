//
//  DetailInfoView.swift
//  BigMoviesAppProgrammatic
//
//  Created by Fatih Özen on 24.03.2023.
//

import UIKit

class DetailInfoView: UIView {

    private let ApiControl: String
    private let movie: MovieResult?
    private let cast: CastResult?
    private var posterImageView: PosterImageView!
    private var titleLabel: UILabel!
    private var dateLabel: UILabel!
    private var genresLabel: UILabel!
    private var avarageLabel: UILabel!
    private var overviewLabel: UILabel!
    private var seasonsLabel: UILabel!
    private var episodesLabel: UILabel!
    
    var viewHeight: CGFloat = 0.0

    init(frame: CGRect, movie: MovieResult? = nil, cast: CastResult? = nil, ApiControl: String) {
        if let movie = movie {
            self.movie = movie
        } else {
            self.movie = nil
        }
        if let cast = cast {
            self.cast = cast
        } else {
            self.cast = nil
        }
        self.ApiControl = ApiControl
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let movie = movie {
            configurePosterImageView(movie: movie)
            configureTitleLabel(movie: movie)
            configureDateLabel(movie: movie)
            configureGenresLabel(movie: movie)
            configureAvarageLabel(movie: movie)
            if ApiControl == "tv" {
                configureTVLabel()
            }
            configureOverviewLabel(movie: movie)
        }
        
        if let cast = cast {
            configurePosterImageView(cast: cast)
            configureTitleLabel(cast: cast) // name
            configureDateLabel(cast: cast) // birthday
            configureGenresLabel(cast: cast) // place of birth
            configureAvarageLabel(cast: cast) // departmant
            configureOverviewLabel(cast: cast) // biography
        }
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurePosterImageView(movie: MovieResult? = nil, cast: CastResult? = nil) {
        posterImageView = PosterImageView(frame: .zero)
        self.addSubview(posterImageView)
        
        posterImageView.layer.cornerRadius = 16
        posterImageView.clipsToBounds = true
        var imageWidth = CGFloat.dWidth * 0.4
        var imageHeigth = imageWidth * 1.5
        
        if let movie = movie {
            posterImageView.downloadImage(posterPath: movie._posterPath)
        }
        if let cast = cast {
            posterImageView.downloadImage(posterPath: cast._profilePath)
            imageWidth = CGFloat.dWidth * 0.35
            imageHeigth = CGFloat.dWidth * 0.3 * 1.5
        }
        
        viewHeight += imageWidth * 1.5
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            posterImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            posterImageView.widthAnchor.constraint(equalToConstant: imageWidth),
            posterImageView.heightAnchor.constraint(equalToConstant: imageHeigth)
        ])
    }
    
    func configureTitleLabel(movie: MovieResult? = nil, cast: CastResult? = nil) {
        titleLabel = UILabel(frame: .zero)
        self.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if let movie = movie {
            if ApiControl == "tv" {
                titleLabel.text = movie._name
            } else {
                titleLabel.text = movie._title
            }
        }
        if let cast = cast {
            titleLabel.text = cast._name
        }
        
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 2
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20)
        ])
        
    }
    
    func configureDateLabel(movie: MovieResult? = nil, cast: CastResult? = nil) {
        dateLabel = UILabel(frame: .zero)
        self.addSubview(dateLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if let movie = movie {
            if ApiControl == "tv" {
                dateLabel.text = "📆  " + movie._firstAirDate
            } else {
                dateLabel.text = "📆  " + movie._releaseDate
            }
        }
        if let cast = cast {
            dateLabel.text = "📆  " + cast._birthday
        }
        
        dateLabel.font = .systemFont(ofSize: 20)
        dateLabel.textColor = .secondaryLabel
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }
    
    func configureGenresLabel(movie: MovieResult? = nil, cast: CastResult? = nil) {
        genresLabel = UILabel(frame: .zero)
        self.addSubview(genresLabel)
        
        genresLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if let movie = movie {
            var text = "🎬 "
            
            for item in movie._genres {
                text += " " + item._name + ","
            }
            text.removeLast()
            genresLabel.text = text
        }
        
        if let cast = cast {
            genresLabel.text = cast._placeOfBirth
        }
        
        genresLabel.font = .systemFont(ofSize: 20)
        genresLabel.textColor = .secondaryLabel
        genresLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            genresLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            genresLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            genresLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor)
        ])
    }
    
    func configureAvarageLabel(movie: MovieResult? = nil, cast: CastResult? = nil) {
        avarageLabel = UILabel(frame: .zero)
        self.addSubview(avarageLabel)
        
        avarageLabel.translatesAutoresizingMaskIntoConstraints = false
        if let movie = movie {
            avarageLabel.text = "⭐️  " + String(movie._voteAverage)
        }
        if let cast = cast {
            avarageLabel.text = cast._departmant
        }
        avarageLabel.font = .systemFont(ofSize: 20)
        avarageLabel.textColor = .secondaryLabel
        
        NSLayoutConstraint.activate([
            avarageLabel.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 10),
            avarageLabel.leadingAnchor.constraint(equalTo: genresLabel.leadingAnchor),
            avarageLabel.trailingAnchor.constraint(equalTo: genresLabel.trailingAnchor)
        ])
    }
    
    func configureTVLabel() {
        seasonsLabel = UILabel(frame: .zero)
        episodesLabel = UILabel(frame: .zero)
        self.addSubview(seasonsLabel)
        self.addSubview(episodesLabel)
        
        seasonsLabel.translatesAutoresizingMaskIntoConstraints = false
        episodesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if let movie = movie {
            seasonsLabel.text = "\(movie._numberOfSeasons) Seasons"
            seasonsLabel.font = .systemFont(ofSize: 20)
            seasonsLabel.textColor = .secondaryLabel
            
            episodesLabel.text = "\(movie._episodes) Episodes"
            episodesLabel.font = .systemFont(ofSize: 20)
            episodesLabel.textColor = .secondaryLabel
        }
        
        
        NSLayoutConstraint.activate([
            seasonsLabel.topAnchor.constraint(equalTo: avarageLabel.bottomAnchor, constant: 6),
            seasonsLabel.leadingAnchor.constraint(equalTo: avarageLabel.leadingAnchor),
            seasonsLabel.trailingAnchor.constraint(equalTo: avarageLabel.trailingAnchor),
            episodesLabel.topAnchor.constraint(equalTo: seasonsLabel.bottomAnchor, constant: 3),
            episodesLabel.leadingAnchor.constraint(equalTo: seasonsLabel.leadingAnchor),
            episodesLabel.trailingAnchor.constraint(equalTo: episodesLabel.trailingAnchor)
        ])
    }
    
    func configureOverviewLabel(movie: MovieResult? = nil, cast: CastResult? = nil) {
        overviewLabel = UILabel(frame: .zero)
        self.addSubview(overviewLabel)
        
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if let movie = movie {
            overviewLabel.text = movie._overview
        }
        if let cast = cast {
            overviewLabel.text = cast._biography
        }
        
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
