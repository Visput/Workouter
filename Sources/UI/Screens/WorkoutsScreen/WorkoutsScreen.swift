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
        workoutsSources = WorkoutsSourceFactory(sourceType: .User,
            workoutsProvider: workoutsProvider,
            navigationManager: navigationManager)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        workoutsSources = WorkoutsSourceFactory(sourceType: .User,
            workoutsProvider: workoutsProvider,
            navigationManager: navigationManager)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workoutsProvider.loadWorkouts()
        
        registerForPreviewing()
        configureSearchController()
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
    
    func workoutsProvider(provider: WorkoutsProvider, didUpdateWorkouts workouts: [Workout]) {
        // Fill view with updated workouts.
        fillViewWithWorkoutsSources(workoutsSources)
    }
}

extension WorkoutsScreen: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        workoutsSources.allWorkoutsSource.searchWorkoutsWithText(searchText!)
        workoutsSources.userWorkokutsSource.searchWorkoutsWithText(searchText!)
        fillViewWithWorkoutsSources(workoutsSources)
    }
    
    func didPresentSearchController(searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
    
    func didDismissSearchController(searchController: UISearchController) {
        workoutsSources.allWorkoutsSource.resetSearchResults()
        workoutsSources.userWorkokutsSource.resetSearchResults()
        fillViewWithWorkoutsSources(workoutsSources)
    }
}

extension WorkoutsScreen: UIViewControllerPreviewingDelegate {
    
    func previewingContext(previewingContext: UIViewControllerPreviewing,
        viewControllerForLocation location: CGPoint) -> UIViewController? {
            
            guard !workoutsSources.currentSource.editable,
                let indexPath = workoutsView.workoutsTableView.indexPathForRowAtPoint(location),
                let cell = workoutsView.workoutsTableView.cellForRowAtIndexPath(indexPath) else { return nil }
            
            previewingContext.sourceRect = cell.frame
            
            return workoutsSources.currentSource.previewScreenForCellAtIndexPath(indexPath)
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing,
        commitViewController viewControllerToCommit: UIViewController) {
            
            navigationManager.pushScreen(viewControllerToCommit, animated: true)
    }
    
    private func registerForPreviewing() {
        if traitCollection.forceTouchCapability == .Available {
            registerForPreviewingWithDelegate(self, sourceView: workoutsView.workoutsTableView)
        }
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
        case .User:
            if editable {
                workoutsView.workoutsTableView.setEditing(true, animated: true)
                searchController.enabled = false
                navigationItem.rightBarButtonItem = UIBarButtonItem.greenDoneItemWithAlignment(.Right,
                    target: self,
                    action: Selector("editButtonDidPress:"))
                
            } else {
                workoutsView.workoutsTableView.setEditing(false, animated: true)
                searchController.enabled = true
                navigationItem.rightBarButtonItem = UIBarButtonItem.greenEditItemWithAlignment(.Right,
                    target: self,
                    action: Selector("editButtonDidPress:"))
            }
            
        case .All:
            workoutsView.workoutsTableView.setEditing(false, animated: true)
            searchController.enabled = true
            navigationItem.rightBarButtonItem = nil
        }
    }
}
