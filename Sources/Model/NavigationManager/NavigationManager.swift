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
            let navigationController = window.rootViewController! as! UINavigationController
            navigationController.delegate = self
            navigationControllersStack.removeAll()
            navigationControllersStack.append(navigationController)
        }
    }
    
    private var storyboard: UIStoryboard {
        return window.rootViewController!.storyboard!
    }
    
    private var rootNavigationController: UINavigationController {
        return navigationControllersStack.first!
    }
    
    private var topNavigationController: UINavigationController {
        return navigationControllersStack.last!
    }
    
    private var underTopNavigationController: UINavigationController? {
        let count = navigationControllersStack.count
        guard count > 1 else { return nil }
        return navigationControllersStack[count - 2]
    }
    
    private var navigationControllersStack = [UINavigationController]()
    
    private var rootScreen: UIViewController {
        return rootNavigationController.viewControllers[0]
    }
}

extension NavigationManager {
    
    // Push / Pop screen.
    func pushScreen(screen: UIViewController, animated: Bool) {
        pushScreen(screen, inNavigationController: topNavigationController, animated: animated)
    }
    
    func popScreenAnimated(animated: Bool) {
        popScreenInNavigationController(topNavigationController, animated: animated)
    }
    
    func popToRootScreenAnimated(animated: Bool) {
        popToRootScreenInNavigationController(topNavigationController, animated: animated)
    }
    
    private func pushScreen(screen: UIViewController,
        inNavigationController navigationController: UINavigationController,
        animated: Bool) {
            navigationController.pushViewController(screen, animated: animated)
            
            // We use custom navigation back buttons.
            // So we have to munually manage pop gesture.
            navigationController.interactivePopGestureRecognizer?.delegate = self
            navigationController.interactivePopGestureRecognizer?.enabled = true
    }
    
    private func setScreens(screens: [UIViewController],
        inNavigationController navigationController: UINavigationController,
        animated: Bool) {
            navigationController.setViewControllers(screens, animated: animated)
            
            // We use custom navigation back buttons.
            // So we have to munually manage pop gesture.
            navigationController.interactivePopGestureRecognizer?.delegate = self
            navigationController.interactivePopGestureRecognizer?.enabled = true
    }
    
    private func popScreenInNavigationController(navigationController: UINavigationController,
        animated: Bool) {
            navigationController.popViewControllerAnimated(animated)
    }
    
    private func popToRootScreenInNavigationController(navigationController: UINavigationController,
        animated: Bool) {
            navigationController.popToRootViewControllerAnimated(animated)
    }
    
    // Present / Dismiss screen.
    func dismissScreenAnimated(animated: Bool) {
        if topNavigationController.presentedViewController != nil {
            topNavigationController.dismissViewControllerAnimated(animated, completion: nil)
            
        } else if underTopNavigationController != nil {
            underTopNavigationController!.dismissViewControllerAnimated(animated, completion: nil)
            navigationControllersStack.removeLast()
        }
    }
    
    func dismissToRootScreenAnimated(animated: Bool) {
        let rootNavigationController = self.rootNavigationController
        rootNavigationController.dismissViewControllerAnimated(animated, completion: nil)
        navigationControllersStack.removeAll()
        navigationControllersStack.append(rootNavigationController)
    }
    
    private func presentScreen(screen: UIViewController,
        wrapWithNavigationController: Bool,
        animated: Bool) {
            
            if wrapWithNavigationController {
                let navigationController = UINavigationController(rootViewController: screen)
                navigationController.delegate = self
                
                topNavigationController.presentViewController(navigationController, animated: animated, completion: nil)
                navigationControllersStack.append(navigationController)
            } else {
                topNavigationController.presentViewController(screen, animated: animated, completion: nil)
            }
    }
    
    // Show / Dismiss dialog.
    func showDialog(dialog: UIViewController) {
        // Dialog is allowed to be presented over already presented view controller.
        let presentingViewController = topNavigationController.presentedViewController ?? topNavigationController
        presentingViewController.presentViewController(dialog, animated: false, completion: nil)
    }
    
    func dismissDialog() {
        // Check if dialog was presented over navigation controller or over already presented view controller.
        var presentingViewController: UIViewController = topNavigationController
        if topNavigationController.presentedViewController?.presentedViewController != nil {
            presentingViewController = topNavigationController.presentedViewController!
        }
        presentingViewController.dismissViewControllerAnimated(false, completion: nil)
    }
    
    // Show / Hide navigation bar.
    func setNavigationBarHidden(hidden: Bool, animated: Bool) {
        setNavigationBarHidden(hidden, forNavigationController: topNavigationController, animated: animated)
    }
    
    private func setNavigationBarHidden(hidden: Bool,
        forNavigationController navigationController: UINavigationController,
        animated: Bool) {
            navigationController.setNavigationBarHidden(hidden, animated: animated)
    }
}

extension NavigationManager {
    
    func instantiateWorkoutDetailsScreenWithWorkout(workout: Workout) -> WorkoutDetailsScreen {
        let screen = storyboard.instantiateViewControllerWithIdentifier(WorkoutDetailsScreen.className()) as! WorkoutDetailsScreen
        screen.workout = workout
        
        return screen
    }
    
    func instantiateWelcomePageContentControllerWithItem(item: WelcomePageItem) -> WelcomePageContentController {
        let screen = storyboard.instantiateViewControllerWithIdentifier(WelcomePageContentController.className())
            as! WelcomePageContentController
        screen.item = item
        
        return screen
    }
}

extension NavigationManager {
    
    func setWelcomeScreenAsRootAnimated(animated: Bool) {
        let screen = storyboard.instantiateViewControllerWithIdentifier(WelcomeScreen.className()) as! WelcomeScreen
        setScreens([screen], inNavigationController: rootNavigationController, animated: animated)
    }
    
    func pushAuthenticationScreenAnimated(animated: Bool) {
        let screen = storyboard.instantiateViewControllerWithIdentifier(AuthenticationScreen.className()) as! AuthenticationScreen
        pushScreen(screen, inNavigationController: rootNavigationController, animated: animated)
    }
    
    func setMainScreenAsRootAnimated(animated: Bool) {
        let screen = storyboard.instantiateViewControllerWithIdentifier(MainScreen.className()) as! MainScreen
        setScreens([screen], inNavigationController: rootNavigationController, animated: animated)
    }
    
    func pushWorkoutsScreenAnimated(animated: Bool) {
        let screen = storyboard.instantiateViewControllerWithIdentifier(WorkoutsScreen.className()) as! WorkoutsScreen
        pushScreen(screen, inNavigationController: topNavigationController, animated: animated)
    }
    
    func pushWorkoutsScreenFromMainScreenWithSearchActive(searchActive: Bool, animated: Bool) {
        let screen = storyboard.instantiateViewControllerWithIdentifier(WorkoutsScreen.className()) as! WorkoutsScreen
        screen.needsActivateSearch = searchActive
        let screens = [rootScreen, screen]
        setScreens(screens, inNavigationController: rootNavigationController, animated: animated)
    }
    
    func pushWorkoutDetailsScreenWithWorkout(workout: Workout, animated: Bool) {
        let screen = storyboard.instantiateViewControllerWithIdentifier(WorkoutDetailsScreen.className()) as! WorkoutDetailsScreen
        screen.workout = workout
        pushScreen(screen, inNavigationController: topNavigationController, animated: animated)
    }
    
    func pushWorkoutDetailsScreenFromMainScreenWithWorkout(workout: Workout, animated: Bool) {
        let screen = storyboard.instantiateViewControllerWithIdentifier(WorkoutDetailsScreen.className()) as! WorkoutDetailsScreen
        screen.workout = workout
        let screens = [rootScreen, screen]
        setScreens(screens, inNavigationController: rootNavigationController, animated: animated)
    }
    
    func presentWorkoutTemplatesScreenWithRequest(searchRequest: WorkoutsSearchRequest,
        animated: Bool,
        templateDidSelectAction: ((workout: Workout) -> Void)?,
        templateDidCancelAction: (() -> Void)?) {
            
            let screen = storyboard.instantiateViewControllerWithIdentifier(WorkoutTemplatesScreen.className()) as! WorkoutTemplatesScreen
            screen.searchRequest = searchRequest
            screen.templateDidSelectAction = templateDidSelectAction
            screen.templateDidCancelAction = templateDidCancelAction
            presentScreen(screen, wrapWithNavigationController: true, animated: animated)
    }
    
    func pushWorkoutEditScreenWithWorkout(workout: Workout,
        animated: Bool,
        workoutDidEditAction: ((workout: Workout) -> Void)?) {
            
            let screen = storyboard.instantiateViewControllerWithIdentifier(WorkoutEditScreen.className()) as! WorkoutEditScreen
            screen.workout = workout
            screen.workoutDidEditAction = workoutDidEditAction
            pushScreen(screen, inNavigationController: topNavigationController, animated: animated)
    }
    
    func presentWorkoutEditScreenWithWorkout(workout: Workout,
        animated: Bool,
        workoutDidEditAction: ((workout: Workout) -> Void)?,
        workoutDidCancelAction: (() -> Void)?) {
            
            let screen = storyboard.instantiateViewControllerWithIdentifier(WorkoutEditScreen.className()) as! WorkoutEditScreen
            screen.workout = workout
            screen.workoutDidEditAction = workoutDidEditAction
            screen.workoutDidCancelAction = workoutDidCancelAction
            presentScreen(screen, wrapWithNavigationController: true, animated: animated)
    }
    
    func presentStepTemplatesScreenWithRequest(searchRequest: StepsSearchRequest,
        animated: Bool,
        templateDidSelectAction: ((step: Step) -> Void)?,
        templateDidCancelAction: (() -> Void)?) {
            
            let screen = storyboard.instantiateViewControllerWithIdentifier(StepTemplatesScreen.className()) as! StepTemplatesScreen
            screen.searchRequest = searchRequest
            screen.templateDidSelectAction = templateDidSelectAction
            screen.templateDidCancelAction = templateDidCancelAction
            presentScreen(screen, wrapWithNavigationController: true, animated: animated)
    }
    
    func pushStepEditScreenWithStep(step: Step,
        animated: Bool,
        stepDidEditAction: ((step: Step) -> Void)?) {
            
            let screen = storyboard.instantiateViewControllerWithIdentifier(StepEditScreen.className()) as! StepEditScreen
            screen.step = step
            screen.stepDidEditAction = stepDidEditAction
            pushScreen(screen, inNavigationController: topNavigationController, animated: animated)
    }
    
    func presentStepEditScreenWithStep(step: Step,
        animated: Bool,
        stepDidEditAction: ((step: Step) -> Void)?,
        stepDidCancelAction: (() -> Void)?) {
            
            let screen = storyboard.instantiateViewControllerWithIdentifier(StepEditScreen.className()) as! StepEditScreen
            screen.step = step
            screen.stepDidEditAction = stepDidEditAction
            screen.stepDidCancelAction = stepDidCancelAction
            presentScreen(screen, wrapWithNavigationController: true, animated: animated)
    }
    
    func presentSettingsScreenAnimated(animated: Bool, didCancelAction: (() -> Void)?) {
        let screen = storyboard.instantiateViewControllerWithIdentifier(SettingsScreen.className()) as! SettingsScreen
        screen.didCancelAction = didCancelAction
        presentScreen(screen, wrapWithNavigationController: true, animated: animated)
    }
    
    func pushWorkoutPlayerScreenWithWorkout(workout: Workout,
        animated: Bool) {
            let screen = storyboard.instantiateViewControllerWithIdentifier(WorkoutPlayerScreen.className()) as! WorkoutPlayerScreen
            screen.workout = workout
            pushScreen(screen, inNavigationController: topNavigationController, animated: animated)
    }
    
    func pushWorkoutGameScreenAnimated(animated: Bool) {
        let screen = storyboard.instantiateViewControllerWithIdentifier(WorkoutGameScreen.className()) as! WorkoutGameScreen
        pushScreen(screen, inNavigationController: topNavigationController, animated: animated)
    }
    
    func pushStatisticsScreenAnimated(animated: Bool) {
        let screen = storyboard.instantiateViewControllerWithIdentifier(StatisticsScreen.className()) as! StatisticsScreen
        pushScreen(screen, inNavigationController: topNavigationController, animated: animated)
    }
    
    func pushAchievementsScreenAnimated(animated: Bool) {
        let screen = storyboard.instantiateViewControllerWithIdentifier(AchievementsScreen.className()) as! AchievementsScreen
        pushScreen(screen, inNavigationController: topNavigationController, animated: animated)
    }
    
    func pushReferFriendsScreenAnimated(animated: Bool) {
        let screen = storyboard.instantiateViewControllerWithIdentifier(ReferFriendsScreen.className()) as! ReferFriendsScreen
        pushScreen(screen, inNavigationController: topNavigationController, animated: animated)
    }
    
    func showInfoDialogWithTitle(title: String, message: String) {
        let dialog = storyboard.instantiateViewControllerWithIdentifier(TextDialog.className()) as! TextDialog
        dialog.primaryText = title
        dialog.secondaryText = message
        dialog.style = .Info
        showDialog(dialog)
    }
    
    func showErrorDialogWithTitle(title: String, message: String) {
        let dialog = storyboard.instantiateViewControllerWithIdentifier(TextDialog.className()) as! TextDialog
        dialog.primaryText = title
        dialog.secondaryText = message
        dialog.style = .Error
        showDialog(dialog)
    }
}

extension NavigationManager: UINavigationControllerDelegate {
    
    func navigationControllerSupportedInterfaceOrientations(navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        guard let viewController = navigationController.topViewController else { return UIInterfaceOrientationMask.Portrait }
        return viewController.supportedInterfaceOrientations()
    }
}

extension NavigationManager: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard topNavigationController.viewControllers.count > 1 &&
            !topNavigationController.navigationBarHidden else { return false }
        
        return true
    }
}
