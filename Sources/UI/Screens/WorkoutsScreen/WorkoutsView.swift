//
//  WorkoutsView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 3/21/15.
//  Copyright (c) 2015 visput. All rights reserved.
//

import Foundation
import UIKit

final class WorkoutsView: BaseScreenView {
    
    @IBOutlet private(set) weak var workoutsCollectionView: ActionableCollectionView!
    @IBOutlet private(set) weak var segmentedControl: UISegmentedControl!
    @IBOutlet private(set) weak var segmentedControlToolbar: UIToolbar!
    @IBOutlet private(set) weak var searchBar: UISearchBar!
    
    override func didLoad() {
        super.didLoad()
        endEditingOnTouch = false
    }
    
    override func willAppear(animated: Bool) {
        super.willAppear(animated)
        workoutsCollectionView.deselectSelectedItemsAnimated(true)
        
        // Reset bottom space. Required for specific case:
        // Activate search -> 3D touch on workout cell -> navigate to workout details screen -> navigate to back.
        bottomSpace!.constant = 0.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Segmented control.
        let segmentedControlOffset: CGFloat = 16.0
        segmentedControl.frame.origin.x = segmentedControlOffset
        segmentedControl.frame.size.width = segmentedControlToolbar.frame.size.width - 2 * segmentedControlOffset
        
        // Collection view.
        workoutsCollectionView.springFlowLayout.sectionInset.top = 16.0
        workoutsCollectionView.springFlowLayout.sectionInset.bottom = 16.0
        workoutsCollectionView.springFlowLayout.sectionInset.left = 16.0
        workoutsCollectionView.springFlowLayout.sectionInset.right = 16.0
        workoutsCollectionView.springFlowLayout.minimumLineSpacing = 16.0
        
        let cellWidth = workoutsCollectionView.frame.size.width -
            workoutsCollectionView.springFlowLayout.sectionInset.left -
            workoutsCollectionView.springFlowLayout.sectionInset.right
        workoutsCollectionView.springFlowLayout.itemSize = CGSize(width: cellWidth, height: 128.0)
        
    }
}
