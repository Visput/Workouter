//
//  UICollectionView+Deselect.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/5/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func deselectSelectedItemsAnimated(animated: Bool) {
        guard let indexPaths = indexPathsForSelectedItems() else { return }
        
        for indexPath in indexPaths {
            deselectItemAtIndexPath(indexPath, animated: animated)
        }
    }
}
