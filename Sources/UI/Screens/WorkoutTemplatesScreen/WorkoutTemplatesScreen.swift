//
//  WorkoutTemplatesScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/3/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class WorkoutTemplatesScreen: BaseScreen {
    
    var templateDidSelectAction: ((workout: Workout) -> ())?
    var templateDidCancelAction: (() -> ())?
    
    var searchRequest = WorkoutsSearchRequest.emptyTemplatesRequest()
    
    private var workouts = [Workout]()
    
    private var searchController: SearchController!
    
    private var workoutsProvider: WorkoutsProvider {
        return modelProvider.workoutsProvider
    }
    
    private var templatesView: WorkoutTemplatesView {
        return view as! WorkoutTemplatesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        fillViewWithSearchRequest(searchRequest)
        searchWorkoutsWithRequest(searchRequest)
    }
    
    deinit {
        // iOS 9 bug requires to manually remove search controller view from it's superview.
        searchController.view.removeFromSuperview()
    }
}

extension WorkoutTemplatesScreen: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(WorkoutTemplateCell.className()) as! WorkoutTemplateCell
        let workout = workouts[indexPath.row]
        cell.fillWithWorkout(workout)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let workoutNameSufix = NSLocalizedString(" Copy", comment: "")
        
        var workout = workouts[indexPath.row]
        if !workout.isEmpty() {
            workout = workout.workoutBySettingName(workout.name + workoutNameSufix).clone()
        }
        templateDidSelectAction?(workout: workout)
    }
}

extension WorkoutTemplatesScreen: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        searchRequest = searchRequest.requestBySettingSearchText(searchText!)
        
        searchWorkoutsWithRequest(searchRequest)
    }
    
    func didPresentSearchController(searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
}

extension WorkoutTemplatesScreen {
    
    @IBAction private func cancelButtonDidPress(sender: AnyObject) {
        templateDidCancelAction?()
    }
    
    private func configureSearchController() {
        searchController = SearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        templatesView.templatesTableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
    }
    
    private func searchWorkoutsWithRequest(searchRequest: WorkoutsSearchRequest) {
        workouts = [Workout]()
        workouts.append(Workout.emptyWorkout())
        
        let searchResults = workoutsProvider.searchWorkoutsWithRequest(searchRequest)
        workouts.appendContentsOf(searchResults)
        
        templatesView.templatesTableView.reloadData()
    }
    
    private func fillViewWithSearchRequest(searchRequest: WorkoutsSearchRequest) {
        searchController.searchBar.text = searchRequest.searchText
    }
}
