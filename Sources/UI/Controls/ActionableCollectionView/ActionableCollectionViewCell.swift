//
//  ActionableCollectionViewCell.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/9/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

class ActionableCollectionViewCell: BaseCollectionViewCell {
    
    @IBOutlet weak var actionsContentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    dynamic var movingInProgressBorderColor: UIColor = UIColor.lightGrayColor()
    
    // Protected properties (Used by ActionableCollectionView).
    weak var actionableCollectionView: ActionableCollectionView!
    var indexPath: NSIndexPath!
    var actions: [CollectionViewCellAction]?
    
    var expandingEnabled: Bool = false {
        didSet {
            if !expandingEnabled {
                selected = false
                actionableCollectionView.collapseCellAtIndexPath(indexPath)
            }
        }
    }
    
    var actionsEnabled: Bool = false {
        didSet {
            if actionsVisible {
                actionsVisible = false
            }
            scrollView.scrollEnabled = actionsEnabled
            
            if !actionsEnabled {
                actions = nil
            }
        }
    }
    
    var actionsVisible: Bool = false {
        didSet {
            if actionsVisible {
                actionableCollectionView.willShowActionsForCellAtIndexPath(indexPath)
                
                // Shift scroll view frame to expand action items.
                UIView.animateWithDuration(1.0,
                    delay: 0.0,
                    usingSpringWithDamping: 0.7,
                    initialSpringVelocity: 2.0,
                    options: [.CurveEaseIn],
                    animations: {
                        self.scrollView.frame.origin.x = -self.actionsContentView.frame.size.width
                    }, completion: { _ in
                        self.actionableCollectionView.didShowActionsForCellAtIndexPath(self.indexPath)
                })
                
            } else {
                actionableCollectionView.willHideActionsForCellAtIndexPath(indexPath)
                
                updateMovingInProgressAppearance(false, movingActionControl: nil)
                
                // Shift scroll view frame to collapse action items.
                UIView.animateWithDuration(0.8,
                    delay: 0.0,
                    usingSpringWithDamping: 1.0,
                    initialSpringVelocity: 1.0,
                    options: [.CurveEaseIn],
                    animations: {
                        self.scrollView.frame.origin.x = 0.0
                    }, completion: { _ in
                        self.actionableCollectionView.didHideActionsForCellAtIndexPath(self.indexPath)
                })
            }
        }
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if actionsVisible && CGRectContainsPoint(scrollView.frame, point) {
            actionsVisible = false
            return nil
        } else {
            return super.hitTest(point, withEvent: event)
        }
    }
    
    func updateMovingInProgressAppearance(movingInProgress: Bool, movingActionControl: UIControl?) {
        if movingInProgress {
            layer.borderWidth = 1.0
            layer.borderColor = movingInProgressBorderColor.CGColor
            let controlFrame = movingActionControl!.convertRect(movingActionControl!.bounds, toView: self)
            setActionsOverlayOffset(bounds.size.width - controlFrame.origin.x)
        } else {
            layer.borderWidth = 0.0
            layer.borderColor = UIColor.clearColor().CGColor
            setActionsOverlayOffset(0.0)
        }
    }
    
    private func setActionsOverlayOffset(offset: CGFloat) {
        UIView.animateWithDuration(0.8,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            options: [.CurveEaseIn],
            animations: {
                self.scrollView.frame.origin.x = -offset
            }, completion: nil)
    }
}
