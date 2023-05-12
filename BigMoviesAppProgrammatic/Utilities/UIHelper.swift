//
//  UIHelper.swift
//  BigMoviesAppProgrammatic
//
//  Created by Fatih Özen on 21.03.2023.
//

import UIKit

enum UIHelper {
    static func createCollectionFlowLayout(kategori: String? = nil) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        var itemWidth = CGFloat.dWidth * 0.48
        
        if kategori != nil {
            itemWidth = CGFloat.dWidth * 0.4
        }
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: itemWidth, height: (itemWidth * 1.5))
        layout.minimumLineSpacing = 10
        
        return layout
    }
    
    static func createSearchCollectionFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = CGFloat.dWidth * 0.30
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        
        return layout
    }
    
}
