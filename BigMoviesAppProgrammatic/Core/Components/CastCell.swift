//
//  CastCell.swift
//  BigMoviesAppProgrammatic
//
//  Created by Fatih Özen on 28.03.2023.
//

import UIKit

class CastCell: UICollectionViewCell {
    
    static let reuseID = "CastCell"
    
    private var profileImageView: PosterImageView!
    private var nameLabel: UILabel!
    private var characterLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        configureProfileImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        profileImageView.cancelDownload()
        profileImageView.image = nil
        nameLabel.text = ""
        characterLabel.text = ""
    }
    
    private func configureCell() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 16
        clipsToBounds = true
    }

    func configureProfileImageView() {
        profileImageView = PosterImageView(frame: .zero)
        addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: CGFloat.dWidth * 0.35),
            profileImageView.heightAnchor.constraint(equalToConstant: CGFloat.dWidth * 0.3 * 1.5 )
        ])
    }
    
    func setCell(cast: CastResult) {
        profileImageView.downloadImage(posterPath: cast._profilePath)
        configureNames(name: cast._name, character: cast._character)
    }
    
    func configureNames(name: String, character: String) {
        nameLabel = UILabel(frame: .zero)
        addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = name
        nameLabel.font = .boldSystemFont(ofSize: 18)
        nameLabel.textAlignment = .center
        
        characterLabel = UILabel(frame: .zero)
        addSubview(characterLabel)
        
        characterLabel.translatesAutoresizingMaskIntoConstraints = false
        characterLabel.text = character
        characterLabel.font = .systemFont(ofSize: 13)
        characterLabel.textColor = .secondaryLabel
        characterLabel.numberOfLines = 2
        characterLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            characterLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            characterLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            characterLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        ])
    }
}
