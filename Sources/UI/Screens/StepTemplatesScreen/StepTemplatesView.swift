//
//  StepTemplatesView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/3/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class StepTemplatesView: BaseScreenView {
    
    @IBOutlet private(set) weak var templatesCollectionView: ExpandableCollectionView!
    @IBOutlet private(set) weak var searchBar: UISearchBar!
    
    override func didLoad() {
        super.didLoad()
        templatesCollectionView.springFlowLayout.sectionInset.top = 16.0
        templatesCollectionView.springFlowLayout.sectionInset.bottom = 16.0
        templatesCollectionView.springFlowLayout.sectionInset.left = 16.0
        templatesCollectionView.springFlowLayout.sectionInset.right = 16.0
        templatesCollectionView.springFlowLayout.minimumLineSpacing = 16.0
    }
    
    func templateCellSizeAtIndexPath(indexPath: NSIndexPath) -> CGSize {
        var cellSize = CGSizeZero
        cellSize.width = templatesCollectionView.frame.size.width -
            templatesCollectionView.springFlowLayout.sectionInset.left -
            templatesCollectionView.springFlowLayout.sectionInset.right
        
        if templatesCollectionView.expandedCellIndexPath == indexPath {
            cellSize.height = templatesCollectionView.bounds.size.height -
                templatesCollectionView.springFlowLayout.sectionInset.top -
                templatesCollectionView.springFlowLayout.sectionInset.bottom
        } else {
            cellSize.height = 80
        }
        
        return cellSize
    }
}
