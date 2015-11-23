//
//  NavigationManagerswift
//  Workouter
//
//  Created by Uladzimir Papko on 10/27/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class NavigationManager: NSObject {
    
    var window: UIWindow! {
        didSet {
            navigationController.delegate = self
        }
    }
    
    var storyboard: UIStoryboard {
        return window.rootViewController!.storyboard!
    }
    
    var navigationController: UINavigationController {
        return window.rootViewController! as! UINavigationController
    }
}

extension NavigationManager: UINavigationControllerDelegate {
    
    func navigationControllerSupportedInterfaceOrientations(navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        guard let viewController = navigationController.topViewController else { return UIInterfaceOrientationMask.Portrait }
        return viewController.supportedInterfaceOrientations()
    }
}

extension NavigationManager {
    
    func pushScreen(screen: UIViewController, animated: Bool) {
        navigationController.pushViewController(screen, animated: animated)
    }
    
    func popScreenAnimated(animated: Bool) {
        navigationController.popViewControllerAnimated(animated)
    }
    
    func popToRootScreenAnimated(animated: Bool) {
        navigationController.popToRootViewControllerAnimated(animated)
    }
    
    func presentScreen(screen: UIViewController, animated: Bool) {
        let presentationController = UINavigationController(rootViewController: screen)
        presentationController.delegate = self
        
        navigationController.presentViewController(presentationController, animated: animated, completion: nil)
    }
    
    func dismissScreenAnimated(animated: Bool) {
        navigationController.dismissViewControllerAnimated(animated, completion: nil)
    }
    
    func showDialog(dialog: UIViewController, animated: Bool) {
        dialog.modalPresentationStyle = .OverCurrentContext
        navigationController.presentViewController(dialog, animated: animated, completion: nil)
    }
    
    func dismissDialogAnimated(animated: Bool) {
        navigationController.dismissViewControllerAnimated(animated, completion: nil)
    }
    
    private func setScreens(screens: [UIViewController], animated: Bool) {
        navigationController.setViewControllers(screens, animated: animated)
    }
}

extension NavigationManager {
    
    func workoutDetailsScreenWithWorkout(workout: Workout) -> WorkoutDetailsScreen {
        let screen = storyboard.instantiateViewControllerWithIdentifier(WorkoutDetailsScreen.className()) as! WorkoutDetailsScreen
        screen.workout = workout
        
        return screen
    }
    
    func pushWorkoutDetailsScreenFromCurrentScreenWithWorkout(workout: Workout, animated: Bool) {
        let screen = storyboard.instantiateViewControllerWithIdentifier(WorkoutDetailsScreen.className()) as! WorkoutDetailsScreen
        screen.workout = workout
        
        pushScreen(screen, animated: animated)
    }
    
    func pushWorkoutDetailsScreenFromPreviousScreenWithWorkout(workout: Workout, animated: Bool) {
        let screen = storyboard.instantiateViewControllerWithIdentifier(WorkoutDetailsScreen.className()) as! WorkoutDetailsScreen
        screen.workout = workout
        
        var screens = navigationController.viewControllers
        screens.removeLast()
        screens.append(screen)
        
        setScreens(screens, animated: animated)
    }
    
    func pushWorkoutDetailsScreenFromWorkoutsScreenWithWorkout(workout: Workout, animated: Bool) {
        let screen = storyboard.instantiateViewControllerWithIdentifier(WorkoutDetailsScreen.className()) as! WorkoutDetailsScreen
        screen.workout = workout
        
        let screens = [navigationController.viewControllers[0], screen]
        
        setScreens(screens, animated: animated)
    }
}

extension NavigationManager {
    
    func presentStepTemplatesScreenWithRequest(searchRequest: StepsSearchRequest,
        animated: Bool,
        templateDidSelectAction: ((step: Step) -> Void)?,
        templateDidCancelAction: (() -> Void)?) {
            
            let screen = storyboard.instantiateViewControllerWithIdentifier(StepTemplatesScreen.className()) as! StepTemplatesScreen
            screen.searchRequest = searchRequest
            screen.templateDidSelectAction = templateDidSelectAction
            screen.templateDidCancelAction = templateDidCancelAction
            
            presentScreen(screen, animated: animated)
    }
    
    func presentWorkoutTemplatesScreenWithRequest(searchRequest: WorkoutsSearchRequest,
        animated: Bool,
        templateDidSelectAction: ((workout: Workout) -> Void)?,
        templateDidCancelAction: (() -> Void)?) {
            
            let screen = storyboard.instantiateViewControllerWithIdentifier(WorkoutTemplatesScreen.className()) as! WorkoutTemplatesScreen
            screen.searchRequest = searchRequest
            screen.templateDidSelectAction = templateDidSelectAction
            screen.templateDidCancelAction = templateDidCancelAction
            
            presentScreen(screen, animated: animated)
    }
}

extension NavigationManager {
    
    func popToWorkoutsScreenWithSearchActive(searchActive: Bool, animated: Bool) {
        popToRootScreenAnimated(animated)
        let screen = navigationController.viewControllers[0] as! WorkoutsScreen
        screen.needsActivateSearch = searchActive
    }
    
    func pushWorkoutEditScreenFromWorkoutsScreenWithWorkout(workout: Workout,
        animated: Bool,
        workoutDidEditAction: ((workout: Workout) -> Void)?) {
            
            let screen = storyboard.instantiateViewControllerWithIdentifier(WorkoutEditScreen.className()) as! WorkoutEditScreen
            screen.workout = workout
            screen.workoutDidEditAction = workoutDidEditAction
            
            let screens = [navigationController.viewControllers[0], screen]
            
            setScreens(screens, animated: animated)
    }
    
    func pushStepEditScreenFromCurrentScreenWithStep(step: Step,
        animated: Bool,
        stepDidEditAction: ((step: Step) -> Void)?) {
            
            let screen = storyboard.instantiateViewControllerWithIdentifier(StepEditScreen.className()) as! StepEditScreen
            screen.step = step
            screen.stepDidEditAction = stepDidEditAction
            
            pushScreen(screen, animated: animated)
    }
}

extension NavigationManager {
    
    func showInfoDialogWithTitle(title: String, message: String) {
        let dialog = storyboard.instantiateViewControllerWithIdentifier(TextDialog.className()) as! TextDialog
        dialog.primaryText = title
        dialog.secondaryText = message
        dialog.style = .Info
        showDialog(dialog, animated: true)
    }
    
    func showErrorDialogWithTitle(title: String, message: String) {
        let dialog = storyboard.instantiateViewControllerWithIdentifier(TextDialog.className()) as! TextDialog
        dialog.primaryText = title
        dialog.secondaryText = message
        dialog.style = .Error
        showDialog(dialog, animated: true)
    }
}
