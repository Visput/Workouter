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
    
    private var searchResults: [Workout]?
    
    private var currentWorkouts: [Workout] {
        return searchResults ?? workoutsProvider.userWorkouts
    }
    
    weak var collectionView: UICollectionView!
    private weak var viewController: UIViewController!
    private let workoutsProvider: WorkoutsProvider
    private let navigationManager: NavigationManager
    
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
        }
        
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: Selector("deleteButtonDidPress:"), forControlEvents: .TouchUpInside)
        
        cell.cloneButton.tag = indexPath.row
        cell.cloneButton.addTarget(self, action: Selector("cloneButtonDidPress:"), forControlEvents: .TouchUpInside)
        
        cell.reorderButton.tag = indexPath.row
        cell.reorderButton.addTarget(self, action: Selector("reorderButtonDidPress:"), forControlEvents: .TouchUpInside)
        
        // Actions are not enabled while search is active.
        cell.actionsEnabled = searchResults == nil
        
        return cell
    }
    
    func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            
            if editingStyle == .Delete {
                workoutsProvider.removeWorkoutAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            }
    }
    
    func tableView(tableView: UITableView,
        moveRowAtIndexPath sourceIndexPath: NSIndexPath,
        toIndexPath destinationIndexPath: NSIndexPath) {
            
            workoutsProvider.moveWorkoutFromIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
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
                // Reload data after animation completed to update actions buttons tags.
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
                self.collectionView.scrollToItemAtIndexPath(newIndexPath,
                    atScrollPosition: .Bottom,
                    animated: true)
                // Reload data after scrolling completed to update actions buttons tags.
                self.executeAfterDelay(1.0, task: { () -> () in
                    self.collectionView.reloadData()
                })
        })
    }
    
    @objc private func reorderButtonDidPress(sender: UIButton) {
        
    }
}
