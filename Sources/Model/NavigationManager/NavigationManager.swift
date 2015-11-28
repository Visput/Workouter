//
//  NavigationManagerswift
//  Workouter
//
//  Created by Uladzimir Papko on 10/27/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class NavigationManager: NSObject {
    
    var window: UIWindow! {
        didSet {
            navigationController.delegate = self
        }
    }
    
    var screensStoryboard: UIStoryboard {
        return window.rootViewController!.storyboard!
    }
    
    lazy var dialogsStoryboard: UIStoryboard = {
        return UIStoryboard(name: "Dialogs", bundle: NSBundle.mainBundle())
    }()
    
    var navigationController: UINavigationController {
        return window.rootViewController! as! UINavigationController
    }
    
    var isAuthenticationScreenPresented: Bool {
        get {
            return navigationController.presentedViewController != nil &&
            navigationController.presentedViewController!.isKindOfClass(AuthenticationScreen)
        }
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
        if !isAuthenticationScreenPresented {
            navigationController.pushViewController(screen, animated: animated)
        }
    }
    
    func popScreenAnimated(animated: Bool) {
        if !isAuthenticationScreenPresented {
            navigationController.popViewControllerAnimated(animated)
        }
    }
    
    func popToRootScreenAnimated(animated: Bool) {
        if !isAuthenticationScreenPresented {
            navigationController.popToRootViewControllerAnimated(animated)
        }
    }
    
    func presentScreen(screen: UIViewController,
        wrapWithNavigationController: Bool,
        animated: Bool) {
            
            if !isAuthenticationScreenPresented {
                if wrapWithNavigationController {
                    let presentationController = UINavigationController(rootViewController: screen)
                    presentationController.delegate = self
        
                    navigationController.presentViewController(presentationController, animated: animated, completion: nil)
                } else {
                    navigationController.presentViewController(screen, animated: animated, completion: nil)
                }
            }
    }
    
    func dismissScreenAnimated(animated: Bool) {
        navigationController.dismissViewControllerAnimated(animated, completion: nil)
    }
    
    func showDialog(dialog: UIViewController) {
        if !isAuthenticationScreenPresented || dialog.isKindOfClass(TextDialog) {
            window.endEditing(true)
            dialog.modalPresentationStyle = .OverCurrentContext
            
            // Dialog is allowed to be presented over already presented view controller.
            let presentingViewController = navigationController.presentedViewController ?? navigationController
            presentingViewController.presentViewController(dialog, animated: false, completion: nil)
        }
    }
    
    func dismissDialog() {
        // Check if dialog was presented over navigation controller or over already presented view controller.
        var presentingViewController: UIViewController = navigationController
        if navigationController.presentedViewController?.presentedViewController != nil {
            presentingViewController = navigationController.presentedViewController!
        }
        presentingViewController.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func setNavigationBarHidden(hidden: Bool, animated: Bool) {
        navigationController.setNavigationBarHidden(hidden, animated: animated)
    }
    
    private func setScreens(screens: [UIViewController], animated: Bool) {
        if !isAuthenticationScreenPresented {
            navigationController.setViewControllers(screens, animated: animated)
        }
    }
}

extension NavigationManager {
    
    func workoutDetailsScreenWithWorkout(workout: Workout) -> WorkoutDetailsScreen {
        let screen = screensStoryboard.instantiateViewControllerWithIdentifier(WorkoutDetailsScreen.className()) as! WorkoutDetailsScreen
        screen.workout = workout
        
        return screen
    }
    
    func pushWorkoutDetailsScreenFromCurrentScreenWithWorkout(workout: Workout, animated: Bool) {
        let screen = screensStoryboard.instantiateViewControllerWithIdentifier(WorkoutDetailsScreen.className()) as! WorkoutDetailsScreen
        screen.workout = workout
        
        pushScreen(screen, animated: animated)
    }
    
    func pushWorkoutDetailsScreenFromPreviousScreenWithWorkout(workout: Workout, animated: Bool) {
        let screen = screensStoryboard.instantiateViewControllerWithIdentifier(WorkoutDetailsScreen.className()) as! WorkoutDetailsScreen
        screen.workout = workout
        
        var screens = navigationController.viewControllers
        screens.removeLast()
        screens.append(screen)
        
        setScreens(screens, animated: animated)
    }
    
    func pushWorkoutDetailsScreenFromWorkoutsScreenWithWorkout(workout: Workout, animated: Bool) {
        let screen = screensStoryboard.instantiateViewControllerWithIdentifier(WorkoutDetailsScreen.className()) as! WorkoutDetailsScreen
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
            
            let screen = screensStoryboard.instantiateViewControllerWithIdentifier(StepTemplatesScreen.className()) as! StepTemplatesScreen
            screen.searchRequest = searchRequest
            screen.templateDidSelectAction = templateDidSelectAction
            screen.templateDidCancelAction = templateDidCancelAction
            
            presentScreen(screen, wrapWithNavigationController: true, animated: animated)
    }
    
    func presentWorkoutTemplatesScreenWithRequest(searchRequest: WorkoutsSearchRequest,
        animated: Bool,
        templateDidSelectAction: ((workout: Workout) -> Void)?,
        templateDidCancelAction: (() -> Void)?) {
            
            let screen = screensStoryboard.instantiateViewControllerWithIdentifier(WorkoutTemplatesScreen.className()) as! WorkoutTemplatesScreen
            screen.searchRequest = searchRequest
            screen.templateDidSelectAction = templateDidSelectAction
            screen.templateDidCancelAction = templateDidCancelAction
            
            presentScreen(screen, wrapWithNavigationController: true, animated: animated)
    }
    
    func presentAuthenticationScreenAnimated(animated: Bool) {
        let screen = screensStoryboard.instantiateViewControllerWithIdentifier(AuthenticationScreen.className()) as! AuthenticationScreen
        presentScreen(screen, wrapWithNavigationController: false, animated: animated)
    }
}

extension NavigationManager {
    
    func pushWorkoutEditScreenFromWorkoutsScreenWithWorkout(workout: Workout,
        showWorkoutDetailsOnCompletion: Bool,
        animated: Bool,
        workoutDidEditAction: ((workout: Workout) -> Void)?) {
            
            let screen = screensStoryboard.instantiateViewControllerWithIdentifier(WorkoutEditScreen.className()) as! WorkoutEditScreen
            screen.workout = workout
            screen.showWorkoutDetailsOnCompletion = showWorkoutDetailsOnCompletion
            screen.workoutDidEditAction = workoutDidEditAction
            
            let screens = [navigationController.viewControllers[0], screen]
            
            setScreens(screens, animated: animated)
    }
    
    func pushWorkoutEditScreenFromCurrentScreenWithWorkout(workout: Workout,
        showWorkoutDetailsOnCompletion: Bool,
        animated: Bool,
        workoutDidEditAction: ((workout: Workout) -> Void)?) {
            
            let screen = screensStoryboard.instantiateViewControllerWithIdentifier(WorkoutEditScreen.className()) as! WorkoutEditScreen
            screen.workout = workout
            screen.showWorkoutDetailsOnCompletion = showWorkoutDetailsOnCompletion
            screen.workoutDidEditAction = workoutDidEditAction
            
            pushScreen(screen, animated: animated)
    }
}

extension NavigationManager {
    
    func popToWorkoutsScreenWithSearchActive(searchActive: Bool, animated: Bool) {
        popToRootScreenAnimated(animated)
        let screen = navigationController.viewControllers[0] as! WorkoutsScreen
        screen.needsActivateSearch = searchActive
    }
    
    func pushStepEditScreenFromCurrentScreenWithStep(step: Step,
        animated: Bool,
        stepDidEditAction: ((step: Step) -> Void)?) {
            
            let screen = screensStoryboard.instantiateViewControllerWithIdentifier(StepEditScreen.className()) as! StepEditScreen
            screen.step = step
            screen.stepDidEditAction = stepDidEditAction
            
            pushScreen(screen, animated: animated)
    }
    
    func pushSettingsScreenAnimated(animated: Bool) {
        let screen = screensStoryboard.instantiateViewControllerWithIdentifier(SettingsScreen.className()) as! SettingsScreen
        
        pushScreen(screen, animated: animated)
    }
    
    func pushWorkoutPlayerScreenWithWorkout(workout: Workout,
        animated: Bool) {
            let screen = screensStoryboard.instantiateViewControllerWithIdentifier(WorkoutPlayerScreen.className()) as! WorkoutPlayerScreen
            
            pushScreen(screen, animated: animated)
    }
}

extension NavigationManager {
    
    func showInfoDialogWithTitle(title: String, message: String) {
        let dialog = dialogsStoryboard.instantiateViewControllerWithIdentifier(TextDialog.className()) as! TextDialog
        dialog.primaryText = title
        dialog.secondaryText = message
        dialog.style = .Info
        showDialog(dialog)
    }
    
    func showErrorDialogWithTitle(title: String, message: String) {
        let dialog = dialogsStoryboard.instantiateViewControllerWithIdentifier(TextDialog.className()) as! TextDialog
        dialog.primaryText = title
        dialog.secondaryText = message
        dialog.style = .Error
        showDialog(dialog)
    }
}
