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
    private(set) var movingCellCurrentIndexPath: NSIndexPath?
    private(set) var movingCellOriginalIndexPath: NSIndexPath?
    private(set) var defaultContentOffsetToShowActions: CGFloat = 50.0
    
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
            cell.scrollView.delegate = self
            cell.scrollView.exclusiveTouch = true
            
            if let canExpand = actionableDelegate!.collectionView?(self, canExpandCellAtIndexPath: indexPath) {
                cell.expandingEnabled = canExpand
            } else {
                cell.expandingEnabled = false
            }
            
            if let canShowActions = actionableDelegate!.collectionView?(self, canShowActionsForCellAtIndexPath: indexPath) {
                cell.actionsEnabled = canShowActions
                
                if canShowActions {
                    cell.actions = actionableDelegate!.collectionView!(self, actionsForCell: cell, atIndexPath: indexPath)
                    configureCellActions(cell.actions!)
                }
                
            } else {
                cell.actionsEnabled = false
            }
            
            if let gestureRecognizers = cell.gestureRecognizers {
                for gestureRecognizer in gestureRecognizers {
                    if gestureRecognizer is UITapGestureRecognizer {
                        cell.removeGestureRecognizer(gestureRecognizer)
                    }
                }
            }
            let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("cellDidTap:"))
            cell.addGestureRecognizer(tapRecognizer)
            
            return cell
    }
    
    override func beginInteractiveMovementForItemAtIndexPath(indexPath: NSIndexPath) -> Bool {
        springFlowLayout.springBehaviorEnabled = false
        return super.beginInteractiveMovementForItemAtIndexPath(indexPath)
    }
    
    override func updateInteractiveMovementTargetPosition(targetPosition: CGPoint) {
        springFlowLayout.springBehaviorEnabled = false
        super.updateInteractiveMovementTargetPosition(targetPosition)
    }
    
    override func endInteractiveMovement() {
        super.endInteractiveMovement()
        updateIndexPathsForVisibleCells()
        hideCellsActions()
        springFlowLayout.springBehaviorEnabled = true
    }
    
    override func cancelInteractiveMovement() {
        super.cancelInteractiveMovement()
        updateIndexPathsForVisibleCells()
        hideCellsActions()
        springFlowLayout.springBehaviorEnabled = true
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
            self.updateIndexPathsForVisibleCells()
            
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

extension ActionableCollectionView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        // Allow scrolling only in left direction.
        if scrollView.contentOffset.x > 0 {
            scrollView.contentOffset.y = 0
        } else {
            scrollView.contentOffset.x = 0
            scrollView.contentOffset.y = 0
        }
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            
            let cell = cellForSubview(scrollView)
            var contentOffsetToShowActions = defaultContentOffsetToShowActions
            if let contentOffset = actionableDelegate!.collectionView?(self, contentOffsetToShowActionsForCellAtIndexPath: cell.indexPath) {
                contentOffsetToShowActions = contentOffset
            }
            if scrollView.contentOffset.x >= contentOffsetToShowActions {
                cell.actionsVisible = true
            }
    }
}

extension ActionableCollectionView {
    
    @objc private func customActionDidSelect(control: UIControl) {
        let cell = cellForSubview(control)
        cell.actionsVisible = false
        let cellAction = cellActionForControl(control, inCellActions: cell.actions!)
        actionableDelegate!.collectionView!(self, didSelectCustomAction: cellAction, forCellAtIndexPath: cell.indexPath)
    }
    
    @objc private func deleteActionDidSelect(control: UIControl) {
        let cell = cellForSubview(control)
        cell.actionsVisible = false
        
        performBatchUpdates({
            let cellAction = self.cellActionForControl(control, inCellActions: cell.actions!)
            self.actionableDelegate!.collectionView!(self, didSelectDeleteAction: cellAction, forCellAtIndexPath: cell.indexPath)
            
            self.deleteItemsAtIndexPaths([cell.indexPath])
            
            }, completion: { _ in
                // Reload data to prevent strange crashes (UICollectionView issue).
                self.reloadData()
        })
    }
    
    @objc private func cloneActionDidSelect(control: UIControl) {
        let cell = cellForSubview(control)
        cell.actionsVisible = false
        
        let cloneIndexPath = NSIndexPath(forItem: cell.indexPath.item + 1, inSection: cell.indexPath.section)
        
        performBatchUpdates({
            let cellAction = self.cellActionForControl(control, inCellActions: cell.actions!)
            self.actionableDelegate!.collectionView!(self,
                didSelectCloneAction: cellAction,
                forCellAtIndexPath: cell.indexPath,
                cloneIndexPath: cloneIndexPath)
            
            self.insertItemsAtIndexPaths([cloneIndexPath])
            
            }, completion: { _ in
                // Scroll to show new cell.
                self.scrollToCellAtIndexPath(cloneIndexPath, animated: true)
        })
    }
    
    @objc private func moveActionDidSelect(longPressRecognizer: UILongPressGestureRecognizer) {
        let cell = cellForSubview(longPressRecognizer.view!)
        let cellAction = cellActionForControl(longPressRecognizer.view! as! UIControl, inCellActions: cell.actions!)
        
        if movingCellCurrentIndexPath == nil || movingCellCurrentIndexPath! == cell.indexPath {
            var targetLocation = convertPoint(longPressRecognizer.locationInView(longPressRecognizer.view!),
                fromView: longPressRecognizer.view!)
            
            targetLocation.x = bounds.size.width / 2.0
            
            switch longPressRecognizer.state {
                
            case .Began:
                collapseExpandedCell({
                    cell.updateMovingInProgressAppearance(true, movingActionControl: cellAction.control)
                })
                movingCellOriginalIndexPath = cell.indexPath
                beginInteractiveMovementForItemAtIndexPath(cell.indexPath)
                updateInteractiveMovementTargetPosition(targetLocation)
                movingCellCurrentIndexPath = cell.indexPath
                
            case .Changed:
                updateInteractiveMovementTargetPosition(targetLocation)
                updateIndexPathsForVisibleCells()
                // Update cell index after movement.
                movingCellCurrentIndexPath = cell.indexPath
                
            case .Ended:
                endInteractiveMovement()
                actionableDelegate!.collectionView!(self, didSelectMoveAction: cellAction,
                    forCellAtIndexPath: movingCellOriginalIndexPath!,
                    destinationIndexPath: movingCellCurrentIndexPath!)
                movingCellOriginalIndexPath = nil
                movingCellCurrentIndexPath = nil
                
            default:
                cancelInteractiveMovement()
                movingCellOriginalIndexPath = nil
                movingCellCurrentIndexPath = nil
            }
        } else {
            cell.actionsVisible = false
        }
    }
    
    @objc private func cellDidTap(tapRecognizer: UITapGestureRecognizer) {
        let cell = tapRecognizer.view! as! ActionableCollectionViewCell
        if cell.expandingEnabled {
            cell.selected = false
            switchExpandingStateForCellAtIndexPath(cell.indexPath)
            
        } else {
            cell.selected = true
            actionableDelegate?.collectionView?(self, didSelectCellAtIndexPath: cell.indexPath)
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
    
    private func cellForSubview(subview: UIView) -> ActionableCollectionViewCell {
        if subview is ActionableCollectionViewCell {
            return subview as! ActionableCollectionViewCell
        }
        
        precondition(subview.superview != nil, "View (\(subview) should be subview of ActionableCollectionViewCell object")
        
        if subview.superview! is ActionableCollectionViewCell {
            return subview.superview as! ActionableCollectionViewCell
        }
        
        return cellForSubview(subview.superview!)
    }
    
    private func cellActionForControl(control: UIControl, inCellActions cellActions: [CollectionViewCellAction]) -> CollectionViewCellAction {
        var resultCellAction: CollectionViewCellAction! = nil
        for cellAction in cellActions {
            if cellAction.control == control {
                resultCellAction = cellAction
                break
            }
        }
        return resultCellAction
    }
    
    private func configureCellActions(cellActions: [CollectionViewCellAction]) {
        for action in cellActions {
            action.control.exclusiveTouch = true
            
            switch action.type {
            case .Custom:
                action.control.addTarget(self, action: Selector("customActionDidSelect:"), forControlEvents: .TouchUpInside)
                
            case .Delete:
                action.control.addTarget(self, action: Selector("deleteActionDidSelect:"), forControlEvents: .TouchUpInside)
                
            case .Clone:
                action.control.addTarget(self, action: Selector("cloneActionDidSelect:"), forControlEvents: .TouchUpInside)
                
            case .Move:
                if let gestureRecognizers = action.control.gestureRecognizers {
                    for gestureRecognizer in gestureRecognizers {
                        if gestureRecognizer is UILongPressGestureRecognizer {
                            action.control.removeGestureRecognizer(gestureRecognizer)
                        }
                    }
                }
                let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("moveActionDidSelect:"))
                gestureRecognizer.minimumPressDuration = 0.1
                action.control.addGestureRecognizer(gestureRecognizer)
            }
        }
    }
}
