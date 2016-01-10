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
                cell.actionsVisible = false
                return nil
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
