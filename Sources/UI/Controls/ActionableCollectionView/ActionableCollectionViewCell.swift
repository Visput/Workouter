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
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.exclusiveTouch = true
        }
    }

    dynamic var movingInProgressBorderColor: UIColor = UIColor.lightGrayColor()
    
    // All below methods and properties are protected (Used by ActionableCollectionView).
    var indexPath: NSIndexPath!
    var expandingEnabled: Bool = false
    
    var actions: [CollectionViewCellAction]? {
        didSet {
            scrollView.scrollEnabled = actions != nil
        }
    }
    
    private(set) var actionsVisible: Bool = false
    
    func setActionsVisible(visible: Bool, animated: Bool, completion: () -> Void) {
        actionsVisible = visible
        
        if actionsVisible {
            // Shift scroll view frame to expand action items.
            if animated {
                UIView.animateWithDuration(1.0,
                    delay: 0.0,
                    usingSpringWithDamping: 0.7,
                    initialSpringVelocity: 2.0,
                    options: [.CurveEaseIn],
                    animations: {
                        self.scrollView.frame.origin.x = -self.actionsContentView.frame.size.width
                    }, completion: { _ in
                        completion()
                })
            } else {
                scrollView.frame.origin.x = -actionsContentView.frame.size.width
                completion()
            }
            
        } else {
            updateMovingInProgressAppearance(false, movingActionControl: nil, animated: animated)
            
            // Shift scroll view frame to collapse action items.
            if animated {
                UIView.animateWithDuration(0.8,
                    delay: 0.0,
                    usingSpringWithDamping: 1.0,
                    initialSpringVelocity: 1.0,
                    options: [.CurveEaseIn],
                    animations: {
                        self.scrollView.frame.origin.x = 0.0
                    }, completion: { _ in
                        completion()
                })
            } else {
                scrollView.frame.origin.x = 0.0
                completion()
            }
        }
    }
    
    func updateMovingInProgressAppearance(movingInProgress: Bool, movingActionControl: UIControl?, animated: Bool) {
        if movingInProgress {
            layer.borderWidth = 1.0
            layer.borderColor = movingInProgressBorderColor.CGColor
            let controlFrame = movingActionControl!.convertRect(movingActionControl!.bounds, toView: self)
            setActionsOverlayOffset(bounds.size.width - controlFrame.origin.x, animated: animated)
        } else {
            layer.borderWidth = 0.0
            layer.borderColor = UIColor.clearColor().CGColor
            setActionsOverlayOffset(0.0, animated: animated)
        }
    }
    
    private func setActionsOverlayOffset(offset: CGFloat, animated: Bool) {
        if animated {
            UIView.animateWithDuration(0.8,
                delay: 0.0,
                usingSpringWithDamping: 1.0,
                initialSpringVelocity: 1.0,
                options: [.CurveEaseIn],
                animations: {
                    self.scrollView.frame.origin.x = -offset
                }, completion: nil)
        } else {
            self.scrollView.frame.origin.x = -offset
        }
    }
}
