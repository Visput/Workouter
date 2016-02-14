//
//  WorkoutEditView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 10/25/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class WorkoutEditView: BaseScreenView {
    
    @IBOutlet private(set) weak var doneButton: TintButton!
    @IBOutlet private(set) weak var newStepButton: TintButton!
    @IBOutlet private(set) weak var stepsCollectionView: ActionableCollectionView!
    
    override func didLoad() {
        super.didLoad()
    
        stepsCollectionView.springFlowLayout.sectionInset.top = 16.0
        stepsCollectionView.springFlowLayout.sectionInset.bottom = 2.0
        stepsCollectionView.springFlowLayout.sectionInset.left = 16.0
        stepsCollectionView.springFlowLayout.sectionInset.right = 16.0
        stepsCollectionView.springFlowLayout.minimumLineSpacing = 16.0
    }
    
    func stepCellSizeAtIndexPath(indexPath: NSIndexPath) -> CGSize {
        var cellSize = CGSize(width: 0.0, height: 0.0)
        cellSize.width = stepsCollectionView.frame.size.width -
            stepsCollectionView.springFlowLayout.sectionInset.left -
            stepsCollectionView.springFlowLayout.sectionInset.right
        
        if stepsCollectionView.expandedCellIndexPath == indexPath {
            cellSize.height = stepsCollectionView.bounds.size.height -
                stepsCollectionView.springFlowLayout.sectionInset.top -
                stepsCollectionView.springFlowLayout.sectionInset.bottom
        } else {
            cellSize.height = 80.0
        }
        
        return cellSize
    }
    
    override func keyboardWillShow(notification: NSNotification, keyboardHeight: CGFloat) {
        super.keyboardWillShow(notification, keyboardHeight: keyboardHeight)
        stepsCollectionView.hideCellsActionsAnimated(true)
    }
}
