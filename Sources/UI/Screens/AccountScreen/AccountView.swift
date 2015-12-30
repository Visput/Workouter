//
//  AccountView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/30/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class AccountView: BaseScreenView {

    @IBOutlet private(set) weak var collectionView: UICollectionView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cellsPerRow: CGFloat = 2
        let collectionViewLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let spacing = (collectionView.frame.size.width - cellsPerRow * collectionViewLayout.itemSize.width) / (cellsPerRow + 1)
        
        collectionViewLayout.sectionInset.left = spacing
        collectionViewLayout.sectionInset.right = spacing
        collectionViewLayout.minimumInteritemSpacing = spacing
        
        collectionViewLayout.sectionInset.bottom = 16.0
        collectionViewLayout.sectionInset.top = 16.0
        collectionViewLayout.minimumLineSpacing = 32.0
    }
}
