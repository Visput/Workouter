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
      
        workoutsSources.collectionView = workoutsView.workoutsCollectionView
        fillViewWithWorkoutsSources(workoutsSources)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Handle workouts updates only when view isn't currently displayed.
        workoutsProvider.observers.removeObserver(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        workoutsView.workoutsCollectionView.hideCellsActions()
        setSearchActive(false)
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        // Handle workouts updates only when view isn't currently displayed.
        workoutsProvider.observers.addObserver(self)
        super.viewDidDisappear(animated)
    }
}

extension WorkoutsScreen: WorkoutsProviderObserving {
    
    func workoutsProvider(provider: WorkoutsProvider, didUpdateUserWorkouts userWorkouts: [Workout]) {
        // Fill view with updated workouts.
        fillViewWithWorkoutsSources(workoutsSources)
    }
}

extension WorkoutsScreen: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        workoutsSources.defaultWorkoutsSource.searchWorkoutsWithText(searchText)
        workoutsSources.userWorkokutsSource.searchWorkoutsWithText(searchText)
        fillViewWithWorkoutsSources(workoutsSources)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        setSearchActive(false)
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        // Allow search to be active only if view currently presented.
        // This fixes UI issues that happen when using 3D Touch with search results.
        return workoutsView.appearanceState == .DidAppear
    }
}

extension WorkoutsScreen: UIToolbarDelegate {
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}

extension WorkoutsScreen {
    
    @IBAction private func workoutsSegmentedControlDidChangeValue(sender: UISegmentedControl) {
        workoutsView.workoutsCollectionView.hideCellsActions()
        workoutsSources.currentSourceType = WorkoutsSourceType(rawValue: sender.selectedSegmentIndex)!
        fillViewWithWorkoutsSources(workoutsSources)
    }
    
    @objc private func newWorkoutButtonDidPress(sender: AnyObject) {
        workoutsView.workoutsCollectionView.hideCellsActions()
        
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
        workoutsView.workoutsCollectionView.hideCellsActions()
        setSearchActive(true)
    }
}

extension WorkoutsScreen {
    
    private func setSearchActive(active: Bool) {
        navigationManager.setNavigationBarHidden(active, animated: true)
        if active {
            workoutsView.searchBar.becomeFirstResponder()
        } else {
            workoutsView.searchBar.resignFirstResponder()
            workoutsView.searchBar.text = ""
            workoutsSources.defaultWorkoutsSource.resetSearchResults()
            workoutsSources.userWorkokutsSource.resetSearchResults()
            fillViewWithWorkoutsSources(workoutsSources)
        }
    }
    
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
            navigationItem.rightBarButtonItem = UIBarButtonItem.greenSearchItemWithAlignment(.Right,
                target: self,
                action: Selector("searchWorkoutsButtonDidPress:"))
        }
    }
}
