//
//  DefaultWorkoutsSource.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/1/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

final class DefaultWorkoutsSource: NSObject, WorkoutsSource {
    
    var active: Bool = false
    
    var currentWorkouts: [Workout] {
        return searchResults ?? workoutsProvider.defaultWorkouts
    }
    
    private var searchResults: [Workout]?
    
    weak var collectionView: ActionableCollectionView!
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
            // Set tag to keep reference to workout index.
            cell.cardView.tag = indexPath.row
            
            // Register cell if it's not reused yet.
            if cell.item == nil {
                viewController.registerForPreviewingWithDelegate(self, sourceView: cell.cardView)
            }
        }
        
        let workout = currentWorkouts[indexPath.row]
        let clonedWorkout = workoutsProvider.workoutWithOriginalIdentifier(workout.identifier)
        let item = DefaultWorkoutCellItem(workout: workout, clonedWorkout: clonedWorkout)
        cell.fillWithItem(item)
        cell.didSelectAction = { [unowned self] in
            self.navigationManager.pushWorkoutDetailsScreenWithWorkout(cell.item!.workout, animated: true)
            // Prevent multiple cells selection.
            for cell in collectionView.visibleCells() as! [DefaultWorkoutCell] {
                cell.didSelectAction = nil
            }
        }
        cell.favoriteButton.tag = indexPath.row
        cell.favoriteButton.addTarget(self, action: Selector("favoriteButtonDidPress:"), forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing,
        viewControllerForLocation location: CGPoint) -> UIViewController? {
            
            guard active else { return nil }
            
            // Check if cell is `editable` state.
            let workoutIndex = previewingContext.sourceView.tag
            let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: workoutIndex, inSection: 0)) as! DefaultWorkoutCell
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

extension DefaultWorkoutsSource {
    
    @objc private func favoriteButtonDidPress(sender: UIButton) {
        sender.selected = !sender.selected
        
        let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: sender.tag, inSection: 0)) as! DefaultWorkoutCell
        cell.actionsVisible = false
        
        let item = cell.item!
        var clonedWorkout: Workout? = nil
        
        if sender.selected {
            // Add workout to `My Workouts`.
            clonedWorkout = item.workout.clone()
            workoutsProvider.addWorkout(clonedWorkout!)
        } else {
            // Remove workout from `My Workouts`.
            workoutsProvider.removeWorkout(item.clonedWorkout!)
            clonedWorkout = nil
        }
        
        let updatedItem = DefaultWorkoutCellItem(workout: item.workout, clonedWorkout: clonedWorkout)
        cell.fillWithItem(updatedItem)
    }
}
