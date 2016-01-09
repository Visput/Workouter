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
      
        workoutsSources.collectionView = workoutsView.workoutsCollectionView
        fillViewWithWorkoutsSources(workoutsSources)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Handle workouts updates only when view isn't currently displayed.
        workoutsProvider.observers.removeObserver(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        searchController.active = false
        super.viewWillDisappear(animated)
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
    
    func willDismissSearchController(searchController: UISearchController) {
        navigationManager.setNavigationBarHidden(false, animated: true)
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
    
    @IBAction private func workoutsSegmentedControlDidChangeValue(sender: UISegmentedControl) {
        workoutsSources.currentSourceType = WorkoutsSourceType(rawValue: sender.selectedSegmentIndex)!
        fillViewWithWorkoutsSources(workoutsSources)
    }
    
    @objc private func newWorkoutButtonDidPress(sender: AnyObject) {
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
    
    @objc private func searchWorkoutsButtonDidPress(sender: AnyObject) {
        navigationManager.setNavigationBarHidden(true, animated: true)
        executeAfterDelay(0.2) { () -> () in
            self.searchController.active = true
        }
    }
}

extension WorkoutsScreen {
    
    private func configureSearchController() {
        searchController = SearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        
        workoutsView.searchBar = searchController.searchBar
    }
}

extension WorkoutsScreen {
    
    private func fillViewWithWorkoutsSources(workoutsSources: WorkoutsSourceFactory) {
        workoutsView.segmentedControl.selectedSegmentIndex = workoutsSources.currentSourceType.rawValue
        workoutsView.workoutsCollectionView.delegate = workoutsSources.currentSource
        workoutsView.workoutsCollectionView.dataSource = workoutsSources.currentSource
        workoutsView.workoutsCollectionView.reloadData()
        
        switch workoutsSources.currentSourceType {
        case .UserWorkouts:
            navigationItem.rightBarButtonItem = UIBarButtonItem.greenPlusItemWithAlignment(.Right,
                target: self,
                action: Selector("newWorkoutButtonDidPress:"))
            
        case .DefaultWorkouts:
            navigationItem.rightBarButtonItem = UIBarButtonItem.greenPlusItemWithAlignment(.Right,
                target: self,
                action: Selector("searchWorkoutsButtonDidPress:"))
        }
    }
}
