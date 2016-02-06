//
//  ExpandableCollectionView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 2/4/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

final class ExpandableCollectionView: UICollectionView {
    
    private(set) var expandedCellIndexPath: NSIndexPath?
    private(set) var springFlowLayout: CollectionSpringFlowLayout
    
    required init?(coder aDecoder: NSCoder) {
        springFlowLayout = CollectionSpringFlowLayout()
        super.init(coder: aDecoder)
        collectionViewLayout = springFlowLayout
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        springFlowLayout = CollectionSpringFlowLayout()
        super.init(frame: frame, collectionViewLayout: springFlowLayout)
    }
    
    override func reloadData() {
        let isSpringBehaviorEnabled = springFlowLayout.springBehaviorEnabled
        if isSpringBehaviorEnabled {
            springFlowLayout.springBehaviorEnabled = false
        }
        
        super.reloadData()
        
        if isSpringBehaviorEnabled {
            // Enable spring behavior after delay because  reloading data is async process
            // that take some time to perform all changes.
            executeAfterDelay(0.5, task: {
                self.springFlowLayout.springBehaviorEnabled = true
            })
        }
    }
    
    override func performBatchUpdates(updates: (() -> Void)?, completion: ((Bool) -> Void)?) {
        let isSpringBehaviorEnabled = springFlowLayout.springBehaviorEnabled
        if isSpringBehaviorEnabled {
            springFlowLayout.springBehaviorEnabled = false
        }
        
        super.performBatchUpdates(updates, completion: { (completed: Bool) -> Void in
            if isSpringBehaviorEnabled {
                self.springFlowLayout.springBehaviorEnabled = true
            }
            completion?(completed)
        })
    }
    
    func switchExpandingStateForCellAtIndexPath(indexPath: NSIndexPath) {
        if expandedCellIndexPath == indexPath {
            expandedCellIndexPath = nil
        } else {
            expandedCellIndexPath = indexPath
        }
        
        performBatchUpdates(nil, completion: nil)
        
        if expandedCellIndexPath != nil {
            scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredVertically, animated: true)
        }
    }
}
