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
    
    private var actionableDelegate: ActionableCollectionViewDelegate? {
        get {
            return delegate as? ActionableCollectionViewDelegate
        }
    }
    
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
            // that takes some time to perform all changes.
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
    
    override func dequeueReusableCellWithReuseIdentifier(identifier: String,
        forIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
            let cell = super.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! ActionableCollectionViewCell
            cell.actionableCollectionView = self
            cell.indexPath = indexPath
            
            return cell
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
    
    func switchExpandingStateForCellAtIndexPath(indexPath: NSIndexPath, completion: (() -> Void)? = nil) {
        let oldExpandedCellIndexPath = expandedCellIndexPath
        
        if expandedCellIndexPath == indexPath {
            actionableDelegate?.collectionView?(self, willCollapseCellAtIndexPath: indexPath)
            expandedCellIndexPath = nil
            
        } else {
            if expandedCellIndexPath != nil {
                actionableDelegate?.collectionView?(self, willCollapseCellAtIndexPath: expandedCellIndexPath!)
            }
            actionableDelegate?.collectionView?(self, willExpandCellAtIndexPath: indexPath)
            expandedCellIndexPath = indexPath
            
        }
        
        performBatchUpdates(nil, completion: { _ in
            if oldExpandedCellIndexPath == indexPath {
                self.actionableDelegate?.collectionView?(self, didCollapseCellAtIndexPath: indexPath)
                
            } else {
                if oldExpandedCellIndexPath != nil {
                    self.actionableDelegate?.collectionView?(self, didCollapseCellAtIndexPath: oldExpandedCellIndexPath!)
                }
                self.actionableDelegate?.collectionView?(self, didExpandCellAtIndexPath: indexPath)
            }
            completion?()
        })
        
        if expandedCellIndexPath != nil {
            scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredVertically, animated: true)
        }
    }
    
    func expandCellAtIndexPath(indexPath: NSIndexPath, completion: (() -> Void)? = nil) {
        guard expandedCellIndexPath == nil || (expandedCellIndexPath != nil && expandedCellIndexPath! != indexPath) else {
            completion?()
            return
        }
        switchExpandingStateForCellAtIndexPath(indexPath, completion: completion)
    }
    
    func collapseCellAtIndexPath(indexPath: NSIndexPath, completion: (() -> Void)? = nil) {
        guard expandedCellIndexPath != nil && expandedCellIndexPath! == indexPath else {
            completion?()
            return
        }
        switchExpandingStateForCellAtIndexPath(expandedCellIndexPath!, completion: completion)
    }
    
    func collapseExpandedCell(completion: (() -> Void)? = nil) {
        guard expandedCellIndexPath != nil else {
            completion?()
            return
        }
        switchExpandingStateForCellAtIndexPath(expandedCellIndexPath!, completion: completion)
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
    
    func updateIndexPathsForVisibleCells() {
        for cell in visibleCells() as! [ActionableCollectionViewCell] {
            cell.indexPath = indexPathForCell(cell)!
        }
    }
}

extension ActionableCollectionView {
    
    func didSelectCellAtIndexPath(indexPath: NSIndexPath) {
        actionableDelegate?.collectionView?(self, didSelectCellAtIndexPath: indexPath)
    }
    
    func willShowActionsForCellAtIndexPath(indexPath: NSIndexPath) {
        actionableDelegate?.collectionView?(self, willShowActionsForCellAtIndexPath: indexPath)
    }
    
    func didShowActionsForCellAtIndexPath(indexPath: NSIndexPath) {
        actionableDelegate?.collectionView?(self, didShowActionsForCellAtIndexPath: indexPath)
    }
    
    func willHideActionsForCellAtIndexPath(indexPath: NSIndexPath) {
        actionableDelegate?.collectionView?(self, willHideActionsForCellAtIndexPath: indexPath)
    }
    
    func didHideActionsForCellAtIndexPath(indexPath: NSIndexPath) {
        actionableDelegate?.collectionView?(self, didHideActionsForCellAtIndexPath: indexPath)
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

@objc protocol ActionableCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    
    optional func collectionView(collectionView: ActionableCollectionView, didSelectCellAtIndexPath indexPath: NSIndexPath)
    optional func collectionView(collectionView: ActionableCollectionView, willExpandCellAtIndexPath indexPath: NSIndexPath)
    optional func collectionView(collectionView: ActionableCollectionView, didExpandCellAtIndexPath indexPath: NSIndexPath)
    optional func collectionView(collectionView: ActionableCollectionView, willCollapseCellAtIndexPath indexPath: NSIndexPath)
    optional func collectionView(collectionView: ActionableCollectionView, didCollapseCellAtIndexPath indexPath: NSIndexPath)
    optional func collectionView(collectionView: ActionableCollectionView, willShowActionsForCellAtIndexPath indexPath: NSIndexPath)
    optional func collectionView(collectionView: ActionableCollectionView, didShowActionsForCellAtIndexPath indexPath: NSIndexPath)
    optional func collectionView(collectionView: ActionableCollectionView, willHideActionsForCellAtIndexPath indexPath: NSIndexPath)
    optional func collectionView(collectionView: ActionableCollectionView, didHideActionsForCellAtIndexPath indexPath: NSIndexPath)
}
