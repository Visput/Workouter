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
        navigationController?.navigationBar.setBackgroundImage(UIImage(),
            forBarMetrics: .Default)
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
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "background_white"),
            forBarMetrics: .Default)
        super.viewWillDisappear(animated)
    }
}

extension MainScreen: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            
            let currentController = viewController as! WorkoutPageContentController
            guard currentController.item.index > 0 else { return nil }
            
            let previousPageItem = workoutPageItems[currentController.item.index - 1]
            let previousController = navigationManager.instantiateWorkoutPageContentControllerWithItem(previousPageItem)
            
            return previousController
    }
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
            
            let currentController = viewController as! WorkoutPageContentController
            guard currentController.item.index < workoutPageItems.count - 1 else { return nil }
            
            let nextPageItem = workoutPageItems[currentController.item.index + 1]
            let nextController = navigationManager.instantiateWorkoutPageContentControllerWithItem(nextPageItem)
            
            return nextController
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return workoutPageItems.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        let currentController = workoutsController.viewControllers!.last as! WorkoutPageContentController
        return currentController.item.index
    }
}

extension MainScreen: WorkoutsProviderObserving {
    
    func workoutsProvider(provider: WorkoutsProvider, didUpdateWorkouts workouts: [Workout]) {
        needsReloadWorkouts = true
    }
}

extension MainScreen {
    
    override func configureBarButtonItems() {
        super.configureBarButtonItems()
        navigationItem.leftBarButtonItem = UIBarButtonItem.greenAccountSettingsItemWithAlignment(.Left,
            target: self,
            action: Selector("settingsButtonDidPress:"))
    }
    
    @objc private func settingsButtonDidPress(sender: AnyObject) {
        navigationManager.presentSettingsScreenAnimated(true,
            didCancelAction: { [unowned self] in
                self.navigationManager.dismissScreenAnimated(true)
            })
    }
}

extension MainScreen {
    
    private func reloadWorkoutsController() {
        workoutPageItems.removeAll()
        for (index, workout) in workoutsProvider.workouts.enumerate() {
            let item = WorkoutPageItem(workout: workout, index: index)
            workoutPageItems.append(item)
        }
        
        workoutsController.dataSource = self
        let firstController = navigationManager.instantiateWorkoutPageContentControllerWithItem(workoutPageItems[0])
        workoutsController.setViewControllers([firstController], direction: .Forward, animated: false, completion:nil)
    }
}
