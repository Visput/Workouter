//
//  ActionableCollectionView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/10/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

final class ActionableCollectionView: UICollectionView {
    
    private(set) var springFlowLayout: CollectionSpringFlowLayout
    private(set) var expandedCellIndexPath: NSIndexPath?
    
    required init?(coder aDecoder: NSCoder) {
        springFlowLayout = CollectionSpringFlowLayout()
        super.init(coder: aDecoder)
        collectionViewLayout = springFlowLayout
        
        // Disable selection because custom selection mechanism is used.
        allowsSelection = false
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        springFlowLayout = CollectionSpringFlowLayout()
        super.init(frame: frame, collectionViewLayout: springFlowLayout)
        
        // Disable selection because custom selection mechanism is used.
        allowsSelection = false
    }
}

extension ActionableCollectionView {
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        for cell in visibleCells() as! [ActionableCollectionViewCell] {
            if cell.actionsVisible {
                // Hide action items if touch point is outside of actions content view.
                if !CGRectContainsPoint(convertRect(cell.actionsContentView.frame, fromView: cell.actionsContentView.superview), point) {
                    cell.actionsVisible = false
                }
            }
        }
        
        return super.hitTest(point, withEvent: event)
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
            executeAfterDelay(1.0, task: {
                self.springFlowLayout.springBehaviorEnabled = true
            })
        }
        
        resetExpandedCellIndexPathIfNeeded()
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
            
            self.resetExpandedCellIndexPathIfNeeded()
            
            completion?(completed)
        })
    }
}

extension ActionableCollectionView {
    
    func hideCellsActions() {
        for cell in visibleCells() as! [ActionableCollectionViewCell] {
            if cell.actionsVisible {
                cell.actionsVisible = false
            }
        }
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
    
    func collapseExpandedCell() {
        if expandedCellIndexPath != nil {
            switchExpandingStateForCellAtIndexPath(expandedCellIndexPath!)
        }
    }
    
    func scrollToCellAtIndexPath(indexPath: NSIndexPath, animated: Bool) {
        var targetCellFrame: CGRect! = nil
        
        if let cell = cellForItemAtIndexPath(indexPath) {
            targetCellFrame = convertRect(cell.frame, fromView: cell.superview)
            
        } else {
            // Cell is nil when it's not visible after being inserted to collection view (UICollectionView bug).
            // Manually calculate its frame.
            let previousIndexPath = NSIndexPath(forItem: indexPath.item - 1, inSection: indexPath.section)
            let previousCell = cellForItemAtIndexPath(previousIndexPath)!
            targetCellFrame = convertRect(previousCell.frame, fromView: previousCell.superview)
            targetCellFrame.origin.y += targetCellFrame.size.height + springFlowLayout.minimumLineSpacing
        }
        
        if !CGRectContainsRect(bounds, targetCellFrame) {
            scrollRectToVisible(targetCellFrame, animated: animated)
        }
    }
}

extension ActionableCollectionView {
    
    private func resetExpandedCellIndexPathIfNeeded() {
        // Reset expanded cell index path if it's out of bounds.
        guard expandedCellIndexPath != nil else { return }
        if expandedCellIndexPath!.item >= numberOfItemsInSection(expandedCellIndexPath!.section) {
            expandedCellIndexPath = nil
        }
    }
}
