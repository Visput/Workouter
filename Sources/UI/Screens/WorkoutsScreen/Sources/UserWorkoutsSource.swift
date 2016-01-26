//
//  UserWorkoutsSource.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/1/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

final class UserWorkoutsSource: NSObject, WorkoutsSource {
    
    var active: Bool = false
    
    var currentWorkouts: [Workout] {
        return searchResults ?? workoutsProvider.userWorkouts
    }
    
    private var searchResults: [Workout]?
    
    weak var collectionView: ActionableCollectionView!
    private weak var viewController: UIViewController!
    private let workoutsProvider: WorkoutsProvider
    private let navigationManager: NavigationManager
    
    // Prevent multiple cells reordering.
    private var reorderingCellIndex: Int?
    
    init(viewController: UIViewController,
        workoutsProvider: WorkoutsProvider,
        navigationManager: NavigationManager) {
            
            self.viewController = viewController
            self.workoutsProvider = workoutsProvider
            self.navigationManager = navigationManager
            super.init()
    }
    
    func searchWorkoutsWithText(text: String) {
        let searchRequest = WorkoutsSearchRequest(searchText: text, isTemplates: false, group: .UserWorkouts)
        searchResults = workoutsProvider.searchWorkoutsWithRequest(searchRequest)
    }
    
    func resetSearchResults() {
        searchResults = nil
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentWorkouts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(UserWorkoutCell.className(),
            forIndexPath: indexPath) as! UserWorkoutCell
        
        if viewController.traitCollection.forceTouchCapability == .Available {
            // Set tag to keep reference to workout index.
            cell.cardView.tag = indexPath.row
            
            // Register cell if it's not reused yet.
            if cell.workout == nil {
                viewController.registerForPreviewingWithDelegate(self, sourceView: cell.cardView)
            }
        }
        
        let workout = currentWorkouts[indexPath.row]
        cell.fillWithWorkout(workout)
        cell.didSelectAction = { [unowned self] in
            self.navigationManager.pushWorkoutDetailsScreenWithWorkout(cell.workout!, animated: true)
            // Prevent multiple cells selection.
            for cell in collectionView.visibleCells() as! [UserWorkoutCell] {
                cell.didSelectAction = nil
            }
        }
        
        cell.deleteButton.addTarget(self, action: Selector("deleteButtonDidPress:"), forControlEvents: .TouchUpInside)
        cell.cloneButton.addTarget(self, action: Selector("cloneButtonDidPress:"), forControlEvents: .TouchUpInside)
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: "reorderButtonDidPress:")
        gestureRecognizer.minimumPressDuration = 0.1
        cell.reorderGestureRecognizer = gestureRecognizer
        updateButtonsTagsForCell(cell, index: indexPath.row)
        
        cell.actionsEnabled = searchResults == nil
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        moveItemAtIndexPath sourceIndexPath: NSIndexPath,
        toIndexPath destinationIndexPath: NSIndexPath) {

            workoutsProvider.moveWorkoutFromIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
            updateVisibleCellsButtonsTags()
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing,
        viewControllerForLocation location: CGPoint) -> UIViewController? {
            
            guard active else { return nil }
            
            // Check if cell is `editable` state.
            let workoutIndex = previewingContext.sourceView.tag
            let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: workoutIndex, inSection: 0)) as! UserWorkoutCell
            guard !cell.actionsVisible else { return nil }
            
            let workout = currentWorkouts[workoutIndex]
            let previewScreen = navigationManager.instantiateWorkoutDetailsScreenWithWorkout(workout)
            
            return previewScreen
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing,
        commitViewController viewControllerToCommit: UIViewController) {
            
            navigationManager.pushScreen(viewControllerToCommit, animated: true)
    }
}

extension UserWorkoutsSource {
    
    @objc private func deleteButtonDidPress(sender: UIButton) {
        let indexPath = NSIndexPath(forItem: sender.tag, inSection: 0)
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! UserWorkoutCell
        cell.actionsVisible = false
        
        collectionView.performBatchUpdates({
            self.workoutsProvider.removeWorkoutAtIndex(indexPath.row)
            self.collectionView.deleteItemsAtIndexPaths([indexPath])
            
            }, completion: { _ in
                // Reload data instead of updating buttons tags to prevent strange crashes (UICollectionView issue).
                self.collectionView.reloadData()
        })
    }
    
    @objc private func cloneButtonDidPress(sender: UIButton) {
        let indexPath = NSIndexPath(forItem: sender.tag, inSection: 0)
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! UserWorkoutCell
        cell.actionsVisible = false
        
        let newIndexPath = NSIndexPath(forItem: indexPath.row + 1, inSection: indexPath.section)
        let workoutNameSufix = NSLocalizedString(" Copy", comment: "")
        let workout = cell.workout!
        let clonedWorkout = workout.workoutBySettingName(workout.name + workoutNameSufix).clone()
        
        collectionView.performBatchUpdates({
            self.workoutsProvider.insertWorkout(clonedWorkout, atIndex: newIndexPath.row)
            self.collectionView.insertItemsAtIndexPaths([newIndexPath])
            
            }, completion: { _ in
                // Scroll to show cell with cloned workout.
                var newCellFrame: CGRect! = nil
                
                if let newCell = self.collectionView.cellForItemAtIndexPath(newIndexPath) {
                    newCellFrame = self.collectionView.convertRect(newCell.frame, fromView: newCell.superview)
                    
                } else {
                    // New cell is nil when it's not visible after inserted to collection view (UICollectionView bug).
                    // Manually calculate its frame.
                    let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
                    newCellFrame = self.collectionView.convertRect(cell.frame, fromView: cell.superview)
                    newCellFrame.origin.y += newCellFrame.size.height + flowLayout.minimumLineSpacing
                }
                
                if !CGRectContainsRect(self.collectionView.bounds, newCellFrame) {
                    self.collectionView.scrollRectToVisible(newCellFrame, animated: true)
                }
                self.updateVisibleCellsButtonsTags()
        })
    }
    
    @objc private func reorderButtonDidPress(gesture: UILongPressGestureRecognizer) {
        let indexPath = NSIndexPath(forItem: gesture.view!.tag, inSection: 0)
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? UserWorkoutCell else { return }
        
        if reorderingCellIndex == nil || reorderingCellIndex! == indexPath.row {
            var targetLocation = collectionView.convertPoint(gesture.locationInView(cell.reorderButton), fromView: cell.reorderButton)
            targetLocation.x = collectionView.bounds.size.width / 2.0
            
            switch(gesture.state) {
                
            case .Began:
                reorderingCellIndex = indexPath.row
                collectionView.beginInteractiveMovementForItemAtIndexPath(indexPath)
                collectionView.updateInteractiveMovementTargetPosition(targetLocation)
                cell.applyReorderingInProgressAppearance()
                
            case .Changed:
                collectionView.updateInteractiveMovementTargetPosition(targetLocation)
                updateVisibleCellsButtonsTags()
                // Update cell index after movement.
                reorderingCellIndex = gesture.view!.tag
                
            case .Ended:
                collectionView.endInteractiveMovement()
                updateVisibleCellsButtonsTags()
                cell.actionsVisible = false
                reorderingCellIndex = nil
                
            default:
                collectionView.cancelInteractiveMovement()
                updateVisibleCellsButtonsTags()
                cell.actionsVisible = false
                reorderingCellIndex = nil
            }
        } else {
            cell.actionsVisible = false
        }
    }
    
    private func updateVisibleCellsButtonsTags() {
        for cell in collectionView.visibleCells() as! [UserWorkoutCell] {
            let index = collectionView.indexPathForCell(cell)!.row
            updateButtonsTagsForCell(cell, index: index)
        }
    }
    
    private func updateButtonsTagsForCell(cell: UserWorkoutCell, index: Int) {
        cell.deleteButton.tag = index
        cell.cloneButton.tag = index
        cell.reorderButton.tag = index
    }
}
