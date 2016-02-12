//
//  UserWorkoutsSource.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/1/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

final class UserWorkoutsSource: NSObject, WorkoutsSource, ActionableCollectionViewDelegate {
    
    var active: Bool = false
    
    var currentWorkouts: [Workout] {
        return searchResults ?? workoutsProvider.userWorkouts
    }
    
    private var searchResults: [Workout]?
    
    weak var workoutsCollectionView: ActionableCollectionView!
    private weak var viewController: UIViewController!
    private let workoutsProvider: WorkoutsProvider
    private let navigationManager: NavigationManager
    
    // Used for preventing multiple cells reordering.
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
        let searchRequest = WorkoutsSearchRequest(searchText: text, group: .UserWorkouts)
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
            // Register cell if it's not reused yet.
            if cell.item == nil {
                viewController.registerForPreviewingWithDelegate(self, sourceView: cell)
            }
        }
        
        let item = UserWorkoutCellItem(workout: currentWorkouts[indexPath.item], actionsEnabled: searchResults == nil)
        cell.fillWithItem(item)
        
        cell.deleteButton.addTarget(self, action: Selector("deleteButtonDidPress:"), forControlEvents: .TouchUpInside)
        cell.cloneButton.addTarget(self, action: Selector("cloneButtonDidPress:"), forControlEvents: .TouchUpInside)
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: "reorderButtonDidPress:")
        gestureRecognizer.minimumPressDuration = 0.1
        cell.reorderGestureRecognizer = gestureRecognizer
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        moveItemAtIndexPath sourceIndexPath: NSIndexPath,
        toIndexPath destinationIndexPath: NSIndexPath) {

            workoutsProvider.moveUserWorkoutFromIndex(sourceIndexPath.item, toIndex: destinationIndexPath.item)
    }
    
    func collectionView(collectionView: ActionableCollectionView,
        didSelectCellAtIndexPath indexPath: NSIndexPath) {
            
            // Prevent multiple cells selection.
            if active {
                let workout = currentWorkouts[indexPath.item]
                navigationManager.pushWorkoutDetailsScreenWithWorkout(workout, animated: true)
            }
            active = false
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing,
        viewControllerForLocation location: CGPoint) -> UIViewController? {
            
            guard active else { return nil }
            guard reorderingCellIndex == nil else { return nil }
            
            // Check if cell in `editable` state.
            let cell = previewingContext.sourceView as! UserWorkoutCell
            guard !cell.actionsVisible else { return nil }
            
            let workoutIndex = workoutsCollectionView.indexPathForCell(cell)!.item
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
        let cell = workoutsCollectionView.cellForItemAtIndexPath(indexPath) as! UserWorkoutCell
        cell.actionsVisible = false
        
        workoutsCollectionView.performBatchUpdates({
            self.workoutsProvider.removeUserWorkoutAtIndex(indexPath.item)
            self.workoutsCollectionView.deleteItemsAtIndexPaths([indexPath])
            
            }, completion: { _ in
                // Reload data to prevent strange crashes (UICollectionView issue).
                self.workoutsCollectionView.reloadData()
        })
    }
    
    @objc private func cloneButtonDidPress(sender: UIButton) {
        let indexPath = NSIndexPath(forItem: sender.tag, inSection: 0)
        let cell = workoutsCollectionView.cellForItemAtIndexPath(indexPath) as! UserWorkoutCell
        cell.actionsVisible = false
        
        let newIndexPath = NSIndexPath(forItem: indexPath.item + 1, inSection: indexPath.section)
        let workoutNameSufix = NSLocalizedString(" Copy", comment: "")
        let workout = cell.item!.workout
        let clonedWorkout = workout.workoutBySettingName(workout.name + workoutNameSufix).clone()
        
        workoutsCollectionView.performBatchUpdates({
            self.workoutsProvider.insertUserWorkout(clonedWorkout, atIndex: newIndexPath.item)
            self.workoutsCollectionView.insertItemsAtIndexPaths([newIndexPath])
            
            }, completion: { _ in
                // Scroll to show cell with cloned workout.
                self.workoutsCollectionView.scrollToCellAtIndexPath(newIndexPath, animated: true)
        })
    }
    
    @objc private func reorderButtonDidPress(gesture: UILongPressGestureRecognizer) {
        let indexPath = NSIndexPath(forItem: gesture.view!.tag, inSection: 0)
        guard let cell = workoutsCollectionView.cellForItemAtIndexPath(indexPath) as? UserWorkoutCell else { return }
        
        if reorderingCellIndex == nil || reorderingCellIndex! == indexPath.item {
            var targetLocation = workoutsCollectionView.convertPoint(gesture.locationInView(cell.reorderButton), fromView: cell.reorderButton)
            targetLocation.x = workoutsCollectionView.bounds.size.width / 2.0
            
            switch gesture.state {
                
            case .Began:
                workoutsCollectionView.beginInteractiveMovementForItemAtIndexPath(indexPath)
                workoutsCollectionView.updateInteractiveMovementTargetPosition(targetLocation)
                cell.applyReorderingInProgressAppearance()
                reorderingCellIndex = indexPath.item
                
            case .Changed:
                workoutsCollectionView.updateInteractiveMovementTargetPosition(targetLocation)
                workoutsCollectionView.updateIndexPathsForVisibleCells()
                // Update cell index after movement.
                reorderingCellIndex = gesture.view!.tag
                
            case .Ended:
                workoutsCollectionView.endInteractiveMovement()
                reorderingCellIndex = nil
                
            default:
                workoutsCollectionView.cancelInteractiveMovement()
                reorderingCellIndex = nil
            }
        } else {
            cell.actionsVisible = false
        }
    }
}
