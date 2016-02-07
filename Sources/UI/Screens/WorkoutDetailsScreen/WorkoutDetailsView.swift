//
//  WorkoutDetailsView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 10/31/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class WorkoutDetailsView: BaseScreenView {

    @IBOutlet private(set) weak var headerView: UserWorkoutCell!
    @IBOutlet private(set) weak var favoriteButton: TintButton!
    @IBOutlet private(set) weak var stepsCollectionView: ExpandableCollectionView!
    
    override func didLoad() {
        super.didLoad()
        headerView.actionsEnabled = false
        
        stepsCollectionView.springFlowLayout.sectionInset.top = 16.0
        stepsCollectionView.springFlowLayout.sectionInset.bottom = 0.0
        stepsCollectionView.springFlowLayout.sectionInset.left = 16.0
        stepsCollectionView.springFlowLayout.sectionInset.right = 16.0
        stepsCollectionView.springFlowLayout.minimumLineSpacing = 16.0
    }
    
    func templateCellSizeAtIndexPath(indexPath: NSIndexPath) -> CGSize {
        var cellSize = CGSizeZero
        cellSize.width = stepsCollectionView.frame.size.width -
            stepsCollectionView.springFlowLayout.sectionInset.left -
            stepsCollectionView.springFlowLayout.sectionInset.right
        
        if stepsCollectionView.expandedCellIndexPath == indexPath {
            cellSize.height = stepsCollectionView.bounds.size.height -
                stepsCollectionView.springFlowLayout.sectionInset.top -
                stepsCollectionView.springFlowLayout.sectionInset.bottom
        } else {
            cellSize.height = 80
        }
        
        return cellSize
    }
}
