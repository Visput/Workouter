//
//  ActionableCollectionViewDelegate.swift
//  Workouter
//
//  Created by Uladzimir Papko on 2/13/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

@objc protocol ActionableCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    
    // Selection.
    optional func collectionView(collectionView: ActionableCollectionView,
        didSelectCellAtIndexPath indexPath: NSIndexPath)
    
    // Expanding.
    optional func collectionView(collectionView: ActionableCollectionView,
        canExpandCellAtIndexPath indexPath: NSIndexPath) -> Bool
    
    optional func collectionView(collectionView: ActionableCollectionView,
        willExpandCellAtIndexPath indexPath: NSIndexPath)
    
    optional func collectionView(collectionView: ActionableCollectionView,
        didExpandCellAtIndexPath indexPath: NSIndexPath)
    
    optional func collectionView(collectionView: ActionableCollectionView,
        willCollapseCellAtIndexPath indexPath: NSIndexPath)
    
    optional func collectionView(collectionView: ActionableCollectionView,
        didCollapseCellAtIndexPath indexPath: NSIndexPath)
    
    // Actions.
    optional func collectionView(collectionView: ActionableCollectionView,
        canShowActionsForCellAtIndexPath indexPath: NSIndexPath) -> Bool
    
    optional func collectionView(collectionView: ActionableCollectionView,
        actionsForCell cell: ActionableCollectionViewCell,
        atIndexPath indexPath: NSIndexPath) -> [CollectionViewCellAction]
    
    optional func collectionView(collectionView: ActionableCollectionView,
        contentOffsetToShowActionsForCellAtIndexPath indexPath: NSIndexPath) -> CGFloat
    
    optional func collectionView(collectionView: ActionableCollectionView,
        didSelectDeleteAction deleteAction: CollectionViewCellAction,
        forCellAtIndexPath deletedIndexPath: NSIndexPath)
    
    optional func collectionView(collectionView: ActionableCollectionView,
        didSelectCloneAction cloneAction: CollectionViewCellAction,
        forCellAtIndexPath sourceIndexPath: NSIndexPath,
        cloneIndexPath: NSIndexPath)
    
    optional func collectionView(collectionView: ActionableCollectionView,
        didSelectCustomAction customAction: CollectionViewCellAction,
        forCellAtIndexPath indexPath: NSIndexPath)
    
    optional func collectionView(collectionView: ActionableCollectionView,
        didCompleteAction action: CollectionViewCellAction,
        forCellAtIndexPath indexPath: NSIndexPath)
    
    optional func collectionView(collectionView: ActionableCollectionView,
        willShowActionsForCellAtIndexPath indexPath: NSIndexPath)
    
    optional func collectionView(collectionView: ActionableCollectionView,
        didShowActionsForCellAtIndexPath indexPath: NSIndexPath)
    
    optional func collectionView(collectionView: ActionableCollectionView,
        willHideActionsForCellAtIndexPath indexPath: NSIndexPath)
    
    optional func collectionView(collectionView: ActionableCollectionView,
        didHideActionsForCellAtIndexPath indexPath: NSIndexPath)
}
