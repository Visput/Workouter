//
//  WorkoutsScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/28/14.
//  Copyright (c) 2014 visput. All rights reserved.
//

import UIKit

class WorkoutsScreen: BaseScreen {
    
    var needsActivateSearch: Bool? {
        didSet {
            guard isViewDisplayed else { return }
            activateSearchControllerIfNeeded()
        }
    }
    
    private var searchController: SearchController!
    
    private var workoutsProvider: WorkoutsProvider {
        return modelProvider.workoutsProvider
    }
    
    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
    
    private var workoutsView: WorkoutsView {
        return view as! WorkoutsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        workoutsProvider.loadWorkouts()
        
        registerForPreviewing()
        configureSearchController()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setStandardViewMode()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        activateSearchControllerIfNeeded()
    }
}

extension WorkoutsScreen: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutsProvider.workouts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(WorkoutCell.className()) as! WorkoutCell
        let workout = workoutsProvider.workouts[indexPath.row]
        cell.fillWithWorkout(workout)
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return workoutsView.mode == .Edit
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return workoutsView.mode == .Edit
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            workoutsProvider.removeWorkoutAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
        }
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        workoutsProvider.moveWorkoutFromIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let workout = workoutsProvider.workouts[indexPath.row]
        
        if workoutsView.mode == .Edit {
            navigationManager.pushWorkoutEditScreenFromWorkoutsScreenWithWorkout(workout, animated: true) { [unowned self] workout in
                self.workoutsProvider.replaceWorkoutAtIndex(indexPath.row, withWorkout: workout)
                self.workoutsView.workoutsTableView.reloadData()
                self.navigationManager.pushWorkoutDetailsScreenFromPreviousScreenWithWorkout(workout, animated: true)
            }
            
        } else {
            navigationManager.pushWorkoutDetailsScreenFromCurrentScreenWithWorkout(workout, animated: true)
        }
    }
}

extension WorkoutsScreen: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
    
    func didPresentSearchController(searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
}

extension WorkoutsScreen: UIViewControllerPreviewingDelegate {

    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {

        guard workoutsView.mode == .Standard,
            let indexPath = workoutsView.workoutsTableView.indexPathForRowAtPoint(location),
            let cell = workoutsView.workoutsTableView.cellForRowAtIndexPath(indexPath) else { return nil }
        
        previewingContext.sourceRect = cell.frame
        let workout = workoutsProvider.workouts[indexPath.row]
        let previewScreen = navigationManager.workoutDetailsScreenWithWorkout(workout)
        
        return previewScreen
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        navigationManager.pushScreen(viewControllerToCommit, animated: true)
    }
    
    private func registerForPreviewing() {
        if traitCollection.forceTouchCapability == .Available {
            registerForPreviewingWithDelegate(self, sourceView: workoutsView.workoutsTableView)
        }
    }
}

extension WorkoutsScreen {
    
    @IBAction private func modeButtonDidPress(sender: UIBarButtonItem) {
        switchViewMode()
    }

    @IBAction private func newWorkoutButtonDidPress(sender: UIBarButtonItem) {
        navigationManager.pushWorkoutEditScreenFromWorkoutsScreenWithWorkout(nil, animated: true) { [unowned self] workout in
            self.workoutsProvider.addWorkout(workout)
            self.workoutsView.workoutsTableView.reloadData()
            self.navigationManager.pushWorkoutDetailsScreenFromPreviousScreenWithWorkout(workout, animated: true)
        }
    }
}

extension WorkoutsScreen {
    
    private func setStandardViewMode() {
        workoutsView.mode = .Standard
        searchController.enabled = true
    }
    
    private func switchViewMode() {
        workoutsView.switchMode()
        searchController.enabled = !searchController.enabled
    }
}

extension WorkoutsScreen {
    
    private func configureSearchController() {
        searchController = SearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        workoutsView.workoutsTableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
    }
    
    private func activateSearchControllerIfNeeded() {
        guard let activate = needsActivateSearch else { return }
        
        if activate {
            setStandardViewMode()
            searchController.active = true
        } else {
            searchController.active = false
        }
        
        // Request satisfied, reset the trigger.
        needsActivateSearch = nil
    }
}