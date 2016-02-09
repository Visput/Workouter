//
//  CollectionSpringFlowLayout.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/9/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

final class CollectionSpringFlowLayout: UICollectionViewFlowLayout {

    var springBehaviorEnabled = true {
        didSet {
            if !springBehaviorEnabled {
                animator.removeAllBehaviors()
            }
        }
    }
    
    private lazy var animator: UIDynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard springBehaviorEnabled else { return super.layoutAttributesForElementsInRect(rect) }
        
        let contentSize = collectionViewContentSize()
        let contentRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: contentSize)
        let items = super.layoutAttributesForElementsInRect(contentRect)!
        
        let minDamping: CGFloat = 0.2
        let maxDamping: CGFloat = 1.0
        
        if items.count > animator.behaviors.count {
            for (index, item) in items.enumerate() where index >= animator.behaviors.count {
                
                let behavior = UIAttachmentBehavior(item: item, attachedToAnchor: item.center)
                
                behavior.action = {
                    let itemPoint = behavior.items[0].center
                    let anchorPoint = behavior.anchorPoint
                    let distance = abs(itemPoint.y - anchorPoint.y)
                    
                    if distance < 1.0 {
                        behavior.damping = maxDamping
                    } else {
                        behavior.damping = minDamping + (maxDamping - minDamping) / pow(distance, 1 / 2.0)
                    }
                }
                
                behavior.length = 2.0
                behavior.damping = minDamping
                behavior.frequency = 1.0
                
                animator.addBehavior(behavior)
            }
            
        } else if items.count < animator.behaviors.count {
            // Remove all behaviors to prevent enormous bouncing animation.
            animator.removeAllBehaviors()
            return items
        }
        
        return animator.itemsInRect(rect) as? [UICollectionViewLayoutAttributes]
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return animator.layoutAttributesForCellAtIndexPath(indexPath) ?? super.layoutAttributesForItemAtIndexPath(indexPath)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        guard springBehaviorEnabled else { return super.shouldInvalidateLayoutForBoundsChange(newBounds) }
        
        let resistanceWeight: CGFloat = 1500.0
        let distance = newBounds.origin.y - collectionView!.bounds.origin.y
        let touchLocation = collectionView!.panGestureRecognizer.locationInView(collectionView)
        
        for behavior in animator.behaviors as! [UIAttachmentBehavior] {
            let xDistanceFromTouch = abs(touchLocation.x - behavior.anchorPoint.x)
            let yDistanceFromTouch = abs(touchLocation.y - behavior.anchorPoint.y)
            let scrollResistance = (xDistanceFromTouch + yDistanceFromTouch) / resistanceWeight
            
            let item = behavior.items[0]
            if distance < 0 {
                item.center.y += max(distance, distance * scrollResistance)
            } else {
                item.center.y += min(distance, distance * scrollResistance)
            }
            
            animator.updateItemUsingCurrentState(item)
        }
        
        return false
    }
}
