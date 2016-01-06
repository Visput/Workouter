//
//  DefaultWorkoutsSource.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/1/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

final class DefaultWorkoutsSource: NSObject, WorkoutsSource {
    
    /// 'All Workouts' list is immutable.
    var editable: Bool {
        get {
            return false
        }
        
        set { }
    }
    
    private var searchResults: [Workout]?
    
    private var currentWorkouts: [Workout] {
        return searchResults ?? workoutsProvider.defaultWorkouts
    }
    
    private let workoutsProvider: WorkoutsProvider!
    private let navigationManager: NavigationManager!
    
    init(workoutsProvider: WorkoutsProvider, navigationManager: NavigationManager) {
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let workout = currentWorkouts[indexPath.row]
        navigationManager.pushWorkoutDetailsScreenWithWorkout(workout, animated: true)
    }
}
