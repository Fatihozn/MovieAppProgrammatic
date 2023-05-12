//
//  SearchCell.swift
//  BigMoviesAppProgrammatic
//
//  Created by Fatih Özen on 1.05.2023.
//

import UIKit

class SearchCell: UICollectionViewCell {
    
    static let reuseID = "searchCell"
    
    private var posterImageView: PosterImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configCell()
        configImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configCell() {
        backgroundColor = .systemGray4
        layer.cornerRadius = 20
        clipsToBounds = true
    }
    
    override func prepareForReuse() {
        posterImageView.cancelDownload()
        posterImageView.image = nil
    }
    
    func setCell(movie: MovieResult) {
        posterImageView.downloadImage(posterPath: movie._posterPath)
    }
    
    private func configImageView() {
        posterImageView = PosterImageView(frame: .zero)
        addSubview(posterImageView)
        
        posterImageView.pinToEdgeOfView(view: self)
    }
}
