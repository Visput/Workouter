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
    
    /// 'All Workouts' list is immutable.
    var editable: Bool {
        get {
            return false
        }
        
        set {
            workoutsTableView.setEditing(false, animated: true)
        }
    }
    
    private var searchResults: [Workout]?
    
    private var currentWorkouts: [Workout] {
        return searchResults ?? workoutsProvider.defaultWorkouts
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
        let searchRequest = WorkoutsSearchRequest(searchText: text, isTemplates: false, group: .DefaultWorkouts)
        searchResults = workoutsProvider.searchWorkoutsWithRequest(searchRequest)
    }
    
    func resetSearchResults() {
        searchResults = nil
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentWorkouts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(DefaultWorkoutCell.className()) as! DefaultWorkoutCell
        
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let workout = currentWorkouts[indexPath.row]
        navigationManager.pushWorkoutDetailsScreenWithWorkout(workout, animated: true)
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing,
        viewControllerForLocation location: CGPoint) -> UIViewController? {
            
            guard active else { return nil }
            
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
