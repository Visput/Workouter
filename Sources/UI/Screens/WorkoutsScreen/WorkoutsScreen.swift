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
            configurePlaceholdersAnimated(true)
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
    
    private var workoutsPlaceholderController: PlaceholderController!
    private var workoutsSearchPlaceholderController: WorkoutsSearchPlaceholderController!
    
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
        workoutsProvider.observers.addObserver(self)
        
        workoutsSources.workoutsCollectionView = workoutsView.workoutsCollectionView
        fillViewWithWorkoutsSources(workoutsSources)
        configurePlaceholdersAnimated(false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        workoutsSources.currentSource.active = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        workoutsView.workoutsCollectionView.hideCellsActions()
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        setSearchActive(false)
        super.viewDidDisappear(animated)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "WorkoutsPlaceholder" {
            workoutsPlaceholderController = segue.destinationViewController as! PlaceholderController
        } else if segue.identifier! == "WorkoutsSearchPlaceholder" {
            workoutsSearchPlaceholderController = segue.destinationViewController as! WorkoutsSearchPlaceholderController
        }
    }
}

extension WorkoutsScreen: WorkoutsProviderObserving {
    
    func workoutsProvider(provider: WorkoutsProvider, didUpdateUserWorkouts userWorkouts: [Workout]) {
        // Handle workouts updates only when view isn't currently displayed.
        if !isViewDisplayed {
            fillViewWithWorkoutsSources(workoutsSources)
        }
        configurePlaceholdersAnimated(true)
    }
}

extension WorkoutsScreen: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        workoutsSources.defaultWorkoutsSource.searchWorkoutsWithText(searchText)
        workoutsSources.userWorkokutsSource.searchWorkoutsWithText(searchText)
        fillViewWithWorkoutsSources(workoutsSources)
        configurePlaceholdersAnimated(true)
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
        configurePlaceholdersAnimated(false)
    }
    
    @objc private func newWorkoutButtonDidPress(sender: AnyObject) {
        workoutsView.workoutsCollectionView.hideCellsActions()
        
        navigationManager.presentWorkoutEditScreenWithWorkout(Workout.emptyWorkout(),
            animated: true,
            workoutDidEditAction: { [unowned self] workout in
                self.workoutsProvider.addUserWorkout(workout)
                self.navigationManager.dismissScreenAnimated(true)
                self.navigationManager.pushWorkoutDetailsScreenWithWorkout(workout, animated: true)
                
            }, workoutDidCancelAction: { [unowned self] in
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
        navigationController?.setNavigationBarHidden(active, animated: true)
        if active {
            workoutsView.searchBar.becomeFirstResponder()
            if workoutsView.searchBar.text == nil {
                workoutsView.searchBar.text = ""
            }
            workoutsSources.defaultWorkoutsSource.searchWorkoutsWithText(workoutsView.searchBar.text!)
            workoutsSources.userWorkokutsSource.searchWorkoutsWithText(workoutsView.searchBar.text!)
        } else {
            workoutsView.searchBar.resignFirstResponder()
            workoutsView.searchBar.text = ""
            workoutsSources.defaultWorkoutsSource.resetSearchResults()
            workoutsSources.userWorkokutsSource.resetSearchResults()
        }
        
        fillViewWithWorkoutsSources(workoutsSources)
        configurePlaceholdersAnimated(true)
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
    
    private func configurePlaceholdersAnimated(animated: Bool) {
        if workoutsView.searchBar.text?.characters.count != 0 {
            // Search results are presented.
            workoutsPlaceholderController.setVisible(false, animated: animated)
            withVaList([self.workoutsView.searchBar.text!]) { pointer in
                self.workoutsSearchPlaceholderController.placeholderLabel.vp_setAttributedTextFormatArguments(pointer, keepFormat: true)
            }
            workoutsSearchPlaceholderController.setVisible(workoutsSources.currentSource.currentWorkouts.count == 0, animated: animated)
        } else {
            // Full list of workouts is presented.
            workoutsSearchPlaceholderController.setVisible(false, animated: animated)
            workoutsPlaceholderController.setVisible(workoutsSources.currentSource.currentWorkouts.count == 0, animated: animated)
        }
    }
}
