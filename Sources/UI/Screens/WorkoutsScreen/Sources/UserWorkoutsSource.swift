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
    
    var editable: Bool = false {
        didSet {
            workoutsTableView.setEditing(editable, animated: true)
        }
    }
    
    private var searchResults: [Workout]?
    
    private var currentWorkouts: [Workout] {
        return searchResults ?? workoutsProvider.userWorkouts
    }
    
    weak var workoutsTableView: UITableView!
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentWorkouts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(UserWorkoutCell.className()) as! UserWorkoutCell
        
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
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return editable
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return editable
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let workout = currentWorkouts[indexPath.row]
        
        if editable {
            navigationManager.presentWorkoutEditScreenWithWorkout(workout,
                animated: true,
                workoutDidEditAction: { [unowned self] workout in
                    
                    self.workoutsProvider.updateWorkoutAtIndex(indexPath.row, withWorkout: workout)
                    self.navigationManager.dismissScreenAnimated(true)
                    self.navigationManager.pushWorkoutDetailsScreenWithWorkout(workout, animated: true)
                    
                }, workoutDidCancelAction: { [unowned self] in
                    self.navigationManager.dismissScreenAnimated(true)
                })
            
        } else {
            navigationManager.pushWorkoutDetailsScreenWithWorkout(workout, animated: true)
        }
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing,
        viewControllerForLocation location: CGPoint) -> UIViewController? {
            
            guard active && !editable else { return nil }
            
            let workoutIndex = previewingContext.sourceView.tag
            let workout = currentWorkouts[workoutIndex]
            let previewScreen = navigationManager.instantiateWorkoutDetailsScreenWithWorkout(workout)
            
            return previewScreen
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing,
        commitViewController viewControllerToCommit: UIViewController) {
            
            navigationManager.pushScreen(viewControllerToCommit, animated: true)
    }
}
