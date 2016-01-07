//
//  WorkoutsScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/28/14.
//  Copyright (c) 2014 visput. All rights reserved.
//

import UIKit

final class WorkoutsScreen: BaseScreen {
    
    private(set) var workoutsSources: WorkoutsSourceFactory! {
        didSet {
            guard isViewDisplayed else { return }
            fillViewWithWorkoutsSources(workoutsSources)
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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        workoutsSources = WorkoutsSourceFactory(sourceType: .UserWorkouts,
            viewController: self,
            workoutsProvider: workoutsProvider,
            navigationManager: navigationManager)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        workoutsSources = WorkoutsSourceFactory(sourceType: .UserWorkouts,
            viewController: self,
            workoutsProvider: workoutsProvider,
            navigationManager: navigationManager)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workoutsProvider.loadWorkouts()
    
        configureSearchController()
      
        workoutsSources.workoutsTableView = workoutsView.workoutsTableView
        fillViewWithWorkoutsSources(workoutsSources)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Handle workouts updates only when view isn't currently displayed.
        workoutsProvider.observers.removeObserver(self)
        workoutsSources.currentSource.editable = false
        fillViewWithEditableState(workoutsSources.currentSource.editable)
    }
    
    override func viewDidDisappear(animated: Bool) {
        // Handle workouts updates only when view isn't currently displayed.
        workoutsProvider.observers.addObserver(self)
        super.viewDidDisappear(animated)
    }
    
    deinit {
        // iOS 9 bug requires to manually remove search controller view from it's superview.
        searchController?.view.removeFromSuperview()
    }
}

extension WorkoutsScreen: WorkoutsProviderObserving {
    
    func workoutsProvider(provider: WorkoutsProvider, didUpdateUserWorkouts userWorkouts: [Workout]) {
        // Fill view with updated workouts.
        fillViewWithWorkoutsSources(workoutsSources)
    }
}

extension WorkoutsScreen: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        workoutsSources.defaultWorkoutsSource.searchWorkoutsWithText(searchText!)
        workoutsSources.userWorkokutsSource.searchWorkoutsWithText(searchText!)
        fillViewWithWorkoutsSources(workoutsSources)
    }
    
    func didPresentSearchController(searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
    
    func didDismissSearchController(searchController: UISearchController) {
        workoutsSources.defaultWorkoutsSource.resetSearchResults()
        workoutsSources.userWorkokutsSource.resetSearchResults()
        fillViewWithWorkoutsSources(workoutsSources)
    }
}

extension WorkoutsScreen: UIToolbarDelegate {
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}

extension WorkoutsScreen {
    
    @objc private func editButtonDidPress(sender: UIBarButtonItem) {
        // Switch mode.
        workoutsSources.currentSource.editable = !workoutsSources.currentSource.editable
        fillViewWithEditableState(workoutsSources.currentSource.editable)
    }
    
    @IBAction private func workoutsSegmentedControlDidChangeValue(sender: UISegmentedControl) {
        workoutsSources.currentSourceType = WorkoutsSourceType(rawValue: sender.selectedSegmentIndex)!
        workoutsSources.currentSource.editable = false
        fillViewWithWorkoutsSources(workoutsSources)
    }
    
    @IBAction private func newWorkoutButtonDidPress(sender: AnyObject) {
        let searchRequest = WorkoutsSearchRequest(searchText: "", isTemplates: true, group: .AllWorkouts)
        navigationManager.presentWorkoutTemplatesScreenWithRequest(searchRequest,
            animated: true,
            templateDidSelectAction: { [unowned self] workout in
                
                self.navigationManager.pushWorkoutEditScreenWithWorkout(workout,
                    animated: true,
                    workoutDidEditAction: { [unowned self] workout in
                        
                        self.workoutsProvider.addWorkout(workout)
                        self.navigationManager.dismissScreenAnimated(true)
                        self.navigationManager.pushWorkoutDetailsScreenWithWorkout(workout, animated: true)
                    })
                
            }, templateDidCancelAction: {
                self.navigationManager.dismissScreenAnimated(true)
        })
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
}

extension WorkoutsScreen {
    
    private func fillViewWithWorkoutsSources(workoutsSources: WorkoutsSourceFactory) {
        workoutsView.segmentedControl.selectedSegmentIndex = workoutsSources.currentSourceType.rawValue
        workoutsView.workoutsTableView.delegate = workoutsSources.currentSource
        workoutsView.workoutsTableView.dataSource = workoutsSources.currentSource
        workoutsView.workoutsTableView.reloadData()
        fillViewWithEditableState(workoutsSources.currentSource.editable)
    }
    
    private func fillViewWithEditableState(editable: Bool) {
        switch workoutsSources.currentSourceType {
        case .UserWorkouts:
            if editable {
                workoutsView.tableFooterViewHidden = true
                searchController.enabled = false
                navigationItem.rightBarButtonItem = UIBarButtonItem.greenDoneItemWithAlignment(.Right,
                    target: self,
                    action: Selector("editButtonDidPress:"))
                
            } else {
                workoutsView.tableFooterViewHidden = false
                searchController.enabled = true
                navigationItem.rightBarButtonItem = UIBarButtonItem.greenEditItemWithAlignment(.Right,
                    target: self,
                    action: Selector("editButtonDidPress:"))
            }
            
        case .DefaultWorkouts:
            workoutsView.tableFooterViewHidden = true
            searchController.enabled = true
            navigationItem.rightBarButtonItem = nil
        }
    }
}
