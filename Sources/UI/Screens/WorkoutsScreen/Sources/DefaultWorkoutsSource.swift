//
//  DefaultWorkoutsSource.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/1/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

final class DefaultWorkoutsSource: NSObject, WorkoutsSource, ActionableCollectionViewDelegate {
    
    var active: Bool = false
    
    var currentWorkouts: [Workout] {
        return searchResults ?? workoutsProvider.defaultWorkouts
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
        let searchRequest = WorkoutsSearchRequest(searchText: text, group: .DefaultWorkouts)
        searchResults = workoutsProvider.searchWorkoutsWithRequest(searchRequest)
    }
    
    func resetSearchResults() {
        searchResults = nil
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentWorkouts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(DefaultWorkoutCell.className(),
            forIndexPath: indexPath) as! DefaultWorkoutCell
        
        if viewController.traitCollection.forceTouchCapability == .Available {
            // Register cell if it's not reused yet.
            if cell.item == nil {
                viewController.registerForPreviewingWithDelegate(self, sourceView: cell)
            }
        }
        
        let workout = currentWorkouts[indexPath.item]
        let clonedWorkout = workoutsProvider.userWorkoutWithOriginalIdentifier(workout.identifier)
        let item = DefaultWorkoutCellItem(workout: workout, clonedWorkout: clonedWorkout)
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
            
            return true
    }
    
    func collectionView(collectionView: ActionableCollectionView,
        actionsForCell cell: ActionableCollectionViewCell,
        atIndexPath indexPath: NSIndexPath) -> [CollectionViewCellAction] {
            
            let currentCell = cell as! DefaultWorkoutCell
            var actions = [CollectionViewCellAction]()
            actions.append(CollectionViewCellAction(type: .Custom, control: currentCell.favoriteButton))
            
            return actions
    }
    
    func collectionView(collectionView: ActionableCollectionView,
        didSelectCustomAction customAction: CollectionViewCellAction,
        forCellAtIndexPath indexPath: NSIndexPath) {
            
            customAction.control.selected = !customAction.control.selected
            
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! DefaultWorkoutCell
            
            var clonedWorkout: Workout? = nil
            
            if customAction.control.selected {
                // Add workout to `My Workouts`.
                clonedWorkout = cell.item!.workout.clone()
                workoutsProvider.addUserWorkout(clonedWorkout!)
            } else {
                // Remove workout from `My Workouts`.
                workoutsProvider.removeUserWorkout(cell.item!.clonedWorkout!)
                clonedWorkout = nil
            }
            
            let updatedItem = DefaultWorkoutCellItem(workout: cell.item!.workout, clonedWorkout: clonedWorkout)
            cell.fillWithItem(updatedItem)
    }

    
    func previewingContext(previewingContext: UIViewControllerPreviewing,
        viewControllerForLocation location: CGPoint) -> UIViewController? {
            
            guard active else { return nil }
            
            // Check if cell in `editable` state.
            let cell = previewingContext.sourceView as! DefaultWorkoutCell
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
