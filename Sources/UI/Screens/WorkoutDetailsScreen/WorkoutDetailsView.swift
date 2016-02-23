//
//  WorkoutDetailsView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 10/31/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class WorkoutDetailsView: BaseScreenView {

    @IBOutlet private(set) weak var nameLabel: UILabel!
    @IBOutlet private(set) weak var descriptionLabel: UILabel!
    @IBOutlet private(set) weak var stepsCountLabel: UILabel!
    @IBOutlet private(set) weak var durationLabel: UILabel!
    @IBOutlet private(set) weak var favoriteButton: TintButton!
    @IBOutlet private(set) weak var stepsCollectionView: ActionableCollectionView!
    
    override func didLoad() {
        super.didLoad()
        stepsCollectionView.springFlowLayout.sectionInset.top = 16.0
        stepsCollectionView.springFlowLayout.sectionInset.bottom = 2.0
        stepsCollectionView.springFlowLayout.sectionInset.left = 16.0
        stepsCollectionView.springFlowLayout.sectionInset.right = 16.0
        stepsCollectionView.springFlowLayout.minimumLineSpacing = 16.0
    }
    
    func templateCellSizeAtIndexPath(indexPath: NSIndexPath) -> CGSize {
        var cellSize = CGSize(width: 0.0, height: 0.0)
        cellSize.width = stepsCollectionView.frame.size.width -
            stepsCollectionView.springFlowLayout.sectionInset.left -
            stepsCollectionView.springFlowLayout.sectionInset.right
        
        if stepsCollectionView.expandedCellIndexPath == indexPath {
            cellSize.height = stepsCollectionView.bounds.size.height -
                stepsCollectionView.springFlowLayout.sectionInset.top -
                stepsCollectionView.springFlowLayout.sectionInset.bottom
        } else {
            cellSize.height = 115.0
        }
        
        return cellSize
    }
}
