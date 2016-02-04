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
    @IBOutlet private(set) weak var stepsCollectionView: ActionableCollectionView!
    
    var stepsCollectionViewLayout: UICollectionViewFlowLayout {
        return stepsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    func newInstanceForCollectionViewLayout(springEnabled: Bool) -> UICollectionViewFlowLayout {
        let layout = springEnabled ? CollectionSpringFlowLayout() : UICollectionViewFlowLayout()
        layout.sectionInset.top = 16.0
        layout.sectionInset.bottom = 16.0
        layout.minimumLineSpacing = 16.0
        return layout
    }
    
    override func didLoad() {
        super.didLoad()
        headerView.actionsEnabled = false
        stepsCollectionView.collectionViewLayout = newInstanceForCollectionViewLayout(false)
        
        // Disable selection because custom selection mechanism is used.
        stepsCollectionView.allowsSelection = false
    }
    
    func switchExpandingStateForStepCellAtIndexPath(indexPath: NSIndexPath) {
        self.stepsCollectionView.setCollectionViewLayout(self.newInstanceForCollectionViewLayout(false), animated: false)
    }
}
