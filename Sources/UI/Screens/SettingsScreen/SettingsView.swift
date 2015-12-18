//
//  SettingsView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/25/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class SettingsView: BaseScreenView {

    @IBOutlet private(set) weak var collectionView: UICollectionView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cellsPerRow: CGFloat = 2
        let collectionViewLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let inset = (collectionView.frame.size.width - cellsPerRow * collectionViewLayout.itemSize.width) / (cellsPerRow + 1)
        collectionViewLayout.sectionInset.left = inset
        collectionViewLayout.sectionInset.right = inset
    }
}
