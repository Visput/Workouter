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
        
        let item = UserWorkoutCellItem(workout: currentWorkouts[indexPath.item])
        cell.fillWithItem(item)
        
        return cell
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
    
    func collectionView(collectionView: ActionableCollectionView,
        canShowActionsForCellAtIndexPath indexPath: NSIndexPath) -> Bool {
            
            return searchResults == nil
    }
    
    func collectionView(collectionView: ActionableCollectionView,
        actionsForCell cell: ActionableCollectionViewCell,
        atIndexPath indexPath: NSIndexPath) -> [CollectionViewCellAction] {
            
            let currentCell = cell as! UserWorkoutCell
            var actions = [CollectionViewCellAction]()
            actions.append(CollectionViewCellAction(type: .Delete, control: currentCell.deleteButton))
            actions.append(CollectionViewCellAction(type: .Clone, control: currentCell.cloneButton))
            actions.append(CollectionViewCellAction(type: .Move, control: currentCell.moveButton))
            
            return actions
    }
    
    func collectionView(collectionView: ActionableCollectionView,
        didSelectDeleteAction deleteAction: CollectionViewCellAction,
        forCellAtIndexPath deletedIndexPath: NSIndexPath) {
            
            workoutsProvider.removeUserWorkoutAtIndex(deletedIndexPath.item)
    }
    
    func collectionView(collectionView: ActionableCollectionView,
        didSelectCloneAction cloneAction: CollectionViewCellAction,
        forCellAtIndexPath sourceIndexPath: NSIndexPath,
        cloneIndexPath: NSIndexPath) {
            
            let cell = collectionView.cellForItemAtIndexPath(sourceIndexPath) as! UserWorkoutCell
            let workoutNameSufix = NSLocalizedString(" Copy", comment: "")
            let workout = cell.item!.workout
            let clonedWorkout = workout.workoutBySettingName(workout.name + workoutNameSufix).clone()
            workoutsProvider.insertUserWorkout(clonedWorkout, atIndex: cloneIndexPath.item)
    }
    
    func collectionView(collectionView: UICollectionView,
        moveItemAtIndexPath sourceIndexPath: NSIndexPath,
        toIndexPath destinationIndexPath: NSIndexPath) {
            
            workoutsProvider.moveUserWorkoutFromIndex(sourceIndexPath.item, toIndex: destinationIndexPath.item)
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing,
        viewControllerForLocation location: CGPoint) -> UIViewController? {
            
            guard active else { return nil }
            guard workoutsCollectionView.movingCellIndexPath == nil else { return nil }
            
            // Check if cell in `editable` state.
            let cell = previewingContext.sourceView as! UserWorkoutCell
            guard !workoutsCollectionView.actionsVisibleForCell(cell) else { return nil }
            
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
