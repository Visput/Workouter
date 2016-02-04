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
    @IBOutlet private(set) weak var stepsCollectionView: UICollectionView!
    
    var stepCellWidth: CGFloat {
        return stepsCollectionView.frame.size.width -
            stepsCollectionViewLayout.sectionInset.left -
            stepsCollectionViewLayout.sectionInset.right
    }
    
    var stepsCollectionViewLayout: CollectionSpringFlowLayout {
        return stepsCollectionView.collectionViewLayout as! CollectionSpringFlowLayout
    }
    
    override func didLoad() {
        super.didLoad()
        headerView.actionsEnabled = false
        
        let layout = CollectionSpringFlowLayout()
        layout.sectionInset.top = 16.0
        layout.sectionInset.bottom = 16.0
        layout.sectionInset.left = 16.0
        layout.sectionInset.right = 16.0
        layout.minimumLineSpacing = 16.0
        stepsCollectionView.collectionViewLayout = layout
    }
    
    func switchExpandingStateForStepCellAtIndexPath(indexPath: NSIndexPath) {
        stepsCollectionViewLayout.springBehaviorEnabled = false
        stepsCollectionView.performBatchUpdates(nil, completion: { _ in
            self.stepsCollectionViewLayout.springBehaviorEnabled = true
        })
        stepsCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
    }
}
