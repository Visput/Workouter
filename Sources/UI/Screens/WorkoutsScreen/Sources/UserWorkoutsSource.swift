//
//  UserWorkoutsSource.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/1/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

final class UserWorkoutsSource: NSObject, WorkoutsSource {
    
    var editable: Bool = false
    
    private var searchResults: [Workout]?
    
    private var currentWorkouts: [Workout] {
        return searchResults ?? workoutsProvider.userWorkouts
    }
    
    private let workoutsProvider: WorkoutsProvider!
    private let navigationManager: NavigationManager!
    
    init(workoutsProvider: WorkoutsProvider, navigationManager: NavigationManager) {
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
    
    func previewScreenForCellAtIndexPath(indexPath: NSIndexPath) -> UIViewController? {
            let workout = currentWorkouts[indexPath.row]
            let previewScreen = navigationManager.instantiateWorkoutDetailsScreenWithWorkout(workout)
            
            return previewScreen
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentWorkouts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(DefaultWorkoutCell.className()) as! DefaultWorkoutCell
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
        return UITableViewCellEditingStyle.Delete
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
}
