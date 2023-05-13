//
//  Collection+Ext.swift
//  BigMoviesAppProgrammatic
//
//  Created by Fatih Özen on 21.03.2023.
//

import UIKit

extension UICollectionView {
    func reloadOnMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}
