//
//  MainScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/14/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class MainScreen: BaseScreen {
    
    private var workoutPageItems = [WorkoutPageItem]()
    private var workoutsController: UIPageViewController!
    private var needsReloadWorkouts = false
    
    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
    
    private var workoutsProvider: WorkoutsProvider {
        return modelProvider.workoutsProvider
    }
    
    private var mainView: MainView {
        return view as! MainView
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "WorkoutsPages" {
            workoutsController = segue.destinationViewController as! UIPageViewController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workoutsProvider.observers.addObserver(self)
        reloadWorkoutsController()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController!.setNavigationBarHidden(false, animated: animated)
        setTransparentBackgroundForNavigationBar()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Due to internal logic of UIPageViewController it can be
        // updated only when its view is currently displayed.
        if needsReloadWorkouts {
            needsReloadWorkouts = false
            reloadWorkoutsController()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        setWhiteBackgroundForNavigationBar()
        super.viewWillDisappear(animated)
    }
}

extension MainScreen: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            
            let currentController = viewController as! WorkoutPageContentControlling
            guard currentController.item.index > 0 else { return nil }
            
            let previousPageItem = workoutPageItems[currentController.item.index - 1]
            let previousController = previousPageItem.instantiatePageContentController() as! UIViewController
            
            return previousController
    }
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
            
            let currentController = viewController as! WorkoutPageContentControlling
            guard currentController.item.index < workoutPageItems.count - 1 else { return nil }
            
            let nextPageItem = workoutPageItems[currentController.item.index + 1]
            let nextController = nextPageItem.instantiatePageContentController() as! UIViewController
            
            return nextController
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        // Don't show page control if only one page is presented.
        return workoutPageItems.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        let currentController = workoutsController.viewControllers!.last as! WorkoutPageContentControlling
        return currentController.item.index
    }
}

extension MainScreen: WorkoutsProviderObserving {
    
    func workoutsProvider(provider: WorkoutsProvider, didUpdateUserWorkouts userWorkouts: [Workout]) {
        needsReloadWorkouts = true
    }
}

extension MainScreen {
    
    override func configureBarButtonItems() {
        super.configureBarButtonItems()
        navigationItem.leftBarButtonItem = UIBarButtonItem.greenAccountItemWithAlignment(.Left,
            target: self,
            action: #selector(MainScreen.accountButtonDidPress(_:)))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.greenPlusItemWithAlignment(.Right,
            target: self,
            action: #selector(MainScreen.newWorkoutButtonDidPress(_:)))
    }
    
    @objc private func accountButtonDidPress(sender: AnyObject) {
        navigationManager.presentAccountScreenAnimated(true,
            didCancelAction: { [unowned self] in
                self.navigationManager.dismissScreenAnimated(true)
            })
    }
    
    @objc private func newWorkoutButtonDidPress(sender: AnyObject) {
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
}

extension MainScreen {
    
    private func reloadWorkoutsController() {
        workoutsController.delegate = self
        workoutsController.dataSource = self
        workoutPageItems.removeAll()
        
        // Add items for user workouts.
        for (index, workout) in workoutsProvider.userWorkouts.enumerate() {
            var item = WorkoutPageItem(workout: workout, index: index)
            item.instantiatePageContentController = { [unowned self] in
                return self.navigationManager.instantiateWorkoutPageContentControllerWithItem(item)
            }
            workoutPageItems.append(item)
        }
        
        // Add item for ability to create new workout.
        var item = WorkoutPageItem(workout: nil, index: workoutPageItems.count)
        item.instantiatePageContentController = { [unowned self] in
            return self.navigationManager.instantiateNewWorkoutPageContentControllerWithItem(item)
        }
        workoutPageItems.append(item)
        
        // Display first item.
        let firstController = workoutPageItems[0].instantiatePageContentController() as! UIViewController
        workoutsController.setViewControllers([firstController], direction: .Forward, animated: false, completion: { [unowned self] _ in
            // Access page control after delay because UIPageViewController instantiates it asynchronously.
            self.executeAfterDelay(0.1, task: { _ in
                self.workoutsController.pageControl?.hidden = self.workoutPageItems.count <= 1
            })
        })
    }
}
