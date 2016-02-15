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
    private(set) var defaultContentOffsetToShowActions: CGFloat = 50.0
    private(set) var expandedCellIndexPath: NSIndexPath?
    private(set) var movingCellDestinationIndexPath: NSIndexPath?
    private(set) var movingCellSourceIndexPath: NSIndexPath?
    
    /// Cell with currently shown actions.
    private var didShowActionsCell: ActionableCollectionViewCell?
    
    /// Cell with actions that are about to be shown (scrolling in progress).
    private var willShowActionsCell: ActionableCollectionViewCell?
    
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
        var didHideCellActions = false
        let needsHideActionsForOtherCells = didShowActionsCell != nil
        
        for cell in visibleCells() as! [ActionableCollectionViewCell] {
            if actionsVisibleForCell(cell) {
                // Hide action items if touch point is outside of actions content view.
                if !CGRectContainsPoint(convertRect(cell.actionsContentView.frame, fromView: cell.actionsContentView.superview), point) {
                    setActionsVisible(false, forCell: cell)
                    
                    didHideCellActions = true
                }
            } else {
                if needsHideActionsForOtherCells {
                    // Double check that actions are hidden for other cells.
                    // Don't call delegate methods for this hack.
                    cell.setActionsVisible(false, animated: true, completion: {})
                }
            }
        }
        
        if didHideCellActions {
            return nil
        } else {
            return super.hitTest(point, withEvent: event)
        }
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

            configureExpandingForCell(cell, atIndexPath: indexPath)
            configureActionsForCell(cell, atIndexPath: indexPath)
            configureSelectionForCell(cell, atIndexPath: indexPath)
            
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
        springFlowLayout.springBehaviorEnabled = true
    }
    
    override func cancelInteractiveMovement() {
        super.cancelInteractiveMovement()
        springFlowLayout.springBehaviorEnabled = true
    }
}

extension ActionableCollectionView {
    
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
    
    func hideCellsActionsAnimated(animated: Bool) {
        for cell in visibleCells() as! [ActionableCollectionViewCell] {
            setActionsVisible(false, forCell: cell, animated: animated)
        }
    }
    
    func actionsVisibleForCell(cell: ActionableCollectionViewCell) -> Bool {
        return didShowActionsCell != nil && didShowActionsCell! == cell
    }
}

extension ActionableCollectionView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        // Allow scrolling only in left direction.
        if scrollView.contentOffset.x > 0 {
            if didShowActionsCell != nil && didShowActionsCell!.scrollView != scrollView {
                scrollView.contentOffset.x = 0
            }
            
            if willShowActionsCell == nil {
                willShowActionsCell = cellForSubview(scrollView)
                
            } else if willShowActionsCell!.scrollView != scrollView {
                scrollView.contentOffset.x = 0
            }
            
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
            let indexPath = indexPathForCell(cell)!
            var contentOffsetToShowActions = defaultContentOffsetToShowActions
            if let contentOffset = actionableDelegate!.collectionView?(self, contentOffsetToShowActionsForCellAtIndexPath: indexPath) {
                contentOffsetToShowActions = contentOffset
            }
            if scrollView.contentOffset.x >= contentOffsetToShowActions {
                setActionsVisible(true, forCell: cell)
            }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            willShowActionsCell = nil
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        willShowActionsCell = nil
    }
}

extension ActionableCollectionView {
    
    @objc private func customActionDidSelect(control: UIControl) {
        let cell = cellForSubview(control)
        let indexPath = indexPathForCell(cell)!
        setActionsVisible(false, forCell: cell)
        let cellAction = cellActionForControl(control, inCellActions: cell.actions!)
        actionableDelegate!.collectionView!(self, didSelectCustomAction: cellAction, forCellAtIndexPath: indexPath)
        actionableDelegate!.collectionView?(self, didCompleteAction: cellAction, forCellAtIndexPath: indexPath)
    }
    
    @objc private func deleteActionDidSelect(control: UIControl) {
        let cell = cellForSubview(control)
        let indexPath = indexPathForCell(cell)!
        setActionsVisible(false, forCell: cell)
        let cellAction = cellActionForControl(control, inCellActions: cell.actions!)
        
        performBatchUpdates({
            self.actionableDelegate!.collectionView!(self, didSelectDeleteAction: cellAction, forCellAtIndexPath: indexPath)
            
            self.deleteItemsAtIndexPaths([indexPath])
            
            }, completion: { _ in
                // Reload data to prevent strange crashes (UICollectionView issue).
                self.reloadData()
                self.actionableDelegate?.collectionView?(self, didCompleteAction: cellAction, forCellAtIndexPath: indexPath)
        })
    }
    
    @objc private func cloneActionDidSelect(control: UIControl) {
        let cell = cellForSubview(control)
        let indexPath = indexPathForCell(cell)!
        setActionsVisible(false, forCell: cell)
        let cellAction = cellActionForControl(control, inCellActions: cell.actions!)
        let cloneIndexPath = NSIndexPath(forItem: indexPath.item + 1, inSection: indexPath.section)
        
        performBatchUpdates({
            self.actionableDelegate!.collectionView!(self,
                didSelectCloneAction: cellAction,
                forCellAtIndexPath: indexPath,
                cloneIndexPath: cloneIndexPath)
            
            self.insertItemsAtIndexPaths([cloneIndexPath])
            
            }, completion: { _ in
                // Scroll to show new cell.
                self.scrollToCellAtIndexPath(cloneIndexPath, animated: true)
                self.actionableDelegate?.collectionView?(self, didCompleteAction: cellAction, forCellAtIndexPath: indexPath)
        })
    }
    
    @objc private func moveActionDidSelect(longPressRecognizer: UILongPressGestureRecognizer) {
        let cell = cellForSubview(longPressRecognizer.view!)
        let cellAction = cellActionForControl(longPressRecognizer.view! as! UIControl, inCellActions: cell.actions!)
        
        var targetLocation = convertPoint(longPressRecognizer.locationInView(longPressRecognizer.view!),
            fromView: longPressRecognizer.view!)
        
        targetLocation.x = bounds.size.width / 2.0
        
        switch longPressRecognizer.state {
            
        case .Began:
            collapseExpandedCell()
            
            movingCellSourceIndexPath = indexPathForCell(cell)!
            
            beginInteractiveMovementForItemAtIndexPath(movingCellSourceIndexPath!)
            updateInteractiveMovementTargetPosition(targetLocation)
            
            cell.updateMovingInProgressAppearance(true, movingActionControl: cellAction.control, animated: true)
            
            movingCellDestinationIndexPath = indexPathForCell(cell)!
            
        case .Changed:
            updateInteractiveMovementTargetPosition(targetLocation)
            
            // Request new index path after movement updates.
            movingCellDestinationIndexPath = indexPathForCell(cell)!
            
        case .Ended:
            endInteractiveMovement()
            cell.updateMovingInProgressAppearance(false, movingActionControl: cellAction.control, animated: true)
            setActionsVisible(false, forCell: cell)
            actionableDelegate?.collectionView?(self, didCompleteAction: cellAction, forCellAtIndexPath: movingCellSourceIndexPath!)
            
            movingCellSourceIndexPath = nil
            movingCellDestinationIndexPath = nil
            
        default:
            cancelInteractiveMovement()
            cell.updateMovingInProgressAppearance(false, movingActionControl: cellAction.control, animated: true)
            setActionsVisible(false, forCell: cell)
            
            movingCellSourceIndexPath = nil
            movingCellDestinationIndexPath = nil
        }
    }
    
    @objc private func cellDidTap(tapRecognizer: UITapGestureRecognizer) {
        let cell = tapRecognizer.view! as! ActionableCollectionViewCell
        let indexPath = indexPathForCell(cell)!
        
        if cell.expandingEnabled {
            cell.selected = false
            switchExpandingStateForCellAtIndexPath(indexPath)
            
        } else {
            cell.selected = true
            actionableDelegate?.collectionView?(self, didSelectCellAtIndexPath: indexPath)
        }
    }
}

extension ActionableCollectionView {
    
    private func configureExpandingForCell(cell: ActionableCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if let canExpand = actionableDelegate!.collectionView?(self, canExpandCellAtIndexPath: indexPath) {
            cell.expandingEnabled = canExpand
        } else {
            cell.expandingEnabled = false
        }
        if !cell.expandingEnabled {
            cell.selected = false
            collapseCellAtIndexPath(indexPath)
        }
    }
    
    private func configureSelectionForCell(cell: ActionableCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if let gestureRecognizers = cell.gestureRecognizers {
            for gestureRecognizer in gestureRecognizers {
                if gestureRecognizer is UITapGestureRecognizer {
                    cell.removeGestureRecognizer(gestureRecognizer)
                }
            }
        }
        let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("cellDidTap:"))
        cell.addGestureRecognizer(tapRecognizer)
    }
    
    private func configureActionsForCell(cell: ActionableCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        cell.scrollView.delegate = self
        
        if let canShowActions = actionableDelegate!.collectionView?(self, canShowActionsForCellAtIndexPath: indexPath) {
            if canShowActions {
                cell.actions = actionableDelegate!.collectionView!(self, actionsForCell: cell, atIndexPath: indexPath)
                
                for action in cell.actions! {
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
                
            } else {
                cell.actions = nil
            }
        } else {
            cell.actions = nil
        }
        
        setActionsVisible(false, forCell: cell, atIndexPath: indexPath, animated: false)
    }
    
    private func cellActionForControl(control: UIControl,
        inCellActions cellActions: [CollectionViewCellAction]) -> CollectionViewCellAction {
            
            var resultCellAction: CollectionViewCellAction! = nil
            for cellAction in cellActions {
                if cellAction.control == control {
                    resultCellAction = cellAction
                    break
                }
            }
            return resultCellAction
    }
    
    private func setActionsVisible(visible: Bool,
        forCell cell: ActionableCollectionViewCell,
        var atIndexPath indexPath: NSIndexPath? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil) {
            
            if visible {
                precondition(didShowActionsCell == nil || didShowActionsCell! == cell,
                    "Actions can not be shown for multiple cells at the same time.")
                guard !actionsVisibleForCell(cell) else { return }
                didShowActionsCell = cell
            } else {
                guard actionsVisibleForCell(cell) else { return }
                didShowActionsCell = nil
            }
            
            if indexPath == nil {
                indexPath = indexPathForCell(cell)!
            }
            
            if visible {
                actionableDelegate?.collectionView?(self, willShowActionsForCellAtIndexPath: indexPath!)
            } else {
                actionableDelegate?.collectionView?(self, willHideActionsForCellAtIndexPath: indexPath!)
            }
            
            cell.setActionsVisible(visible, animated: animated, completion: {
                if visible {
                    self.actionableDelegate?.collectionView?(self, didShowActionsForCellAtIndexPath: indexPath!)
                } else {
                    self.actionableDelegate?.collectionView?(self, didHideActionsForCellAtIndexPath: indexPath!)
                }
                completion?()
            })
    }
    
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
}
