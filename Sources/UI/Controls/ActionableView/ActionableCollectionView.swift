//
//  ActionableCollectionView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/10/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

class ActionableCollectionView: UICollectionView {
    
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
    
    func hideCellsActions() {
        for cell in visibleCells() as! [ActionableCollectionViewCell] {
            if cell.actionsVisible {
                cell.actionsVisible = false
            }
        }
    }
}
