//
//  WorkoutTemplatesScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/3/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class WorkoutTemplatesScreen: BaseScreen {
    
    var templateDidSelectAction: ((workout: Workout) -> Void)?
    var templateDidCancelAction: (() -> Void)?
    
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
        searchController?.view.removeFromSuperview()
    }
}

extension WorkoutTemplatesScreen: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var resultCell: UITableViewCell! = nil
        
        let workout = workouts[indexPath.row]
        if workout.name.isEmpty {
            resultCell = tableView.dequeueReusableCellWithIdentifier(NewWorkoutTemplateCell.className())
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(WorkoutTemplateCell.className()) as! WorkoutTemplateCell
            cell.fillWithWorkout(workout)
            resultCell = cell
        }
        
        return resultCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let workoutNameSufix = NSLocalizedString(" Copy", comment: "")
        
        var workout = workouts[indexPath.row]
        if !workout.name.isEmpty {
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
    
    override func configureBarButtonItems() {
        super.configureBarButtonItems()
        navigationItem.leftBarButtonItem = UIBarButtonItem.greenCancelItemWithAlignment(.Left,
            target: self,
            action: Selector("cancelButtonDidPress:"))
    }
    
    @objc private func cancelButtonDidPress(sender: AnyObject) {
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
