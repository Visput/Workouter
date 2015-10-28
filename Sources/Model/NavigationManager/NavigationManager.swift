//
//  NavigationManagerswift
//  Workouter
//
//  Created by Uladzimir Papko on 10/27/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class NavigationManager: NSObject {
    
    var window: UIWindow!
    
    var storyboard: UIStoryboard {
        return window.rootViewController!.storyboard!
    }
    
    var navigationController: UINavigationController {
        return window.rootViewController! as! UINavigationController
    }
}

extension NavigationManager {
    
    func pushScreen(screen: UIViewController, animated: Bool) {
        navigationController.pushViewController(screen, animated: animated)
    }
    
    func popScreenAnimated(animated: Bool) {
        navigationController.popViewControllerAnimated(animated)
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
        
        navigationController.pushViewController(screen, animated: animated)
    }
    
    func pushWorkoutDetailsScreenFromPreviousScreenWithWorkout(workout: Workout, animated: Bool) {
        let screen = storyboard.instantiateViewControllerWithIdentifier(WorkoutDetailsScreen.className()) as! WorkoutDetailsScreen
        screen.workout = workout
        
        var screens = navigationController.viewControllers
        screens.removeLast()
        screens.append(screen)
        navigationController.setViewControllers(screens, animated: animated)
    }
    
    func pushWorkoutDetailsScreenFromWorkoutsScreenWithWorkout(workout: Workout, animated: Bool) {
        let screen = storyboard.instantiateViewControllerWithIdentifier(WorkoutDetailsScreen.className()) as! WorkoutDetailsScreen
        screen.workout = workout
        
        let screens = [navigationController.viewControllers[0], screen]
        navigationController.setViewControllers(screens, animated: animated)
    }
}

extension NavigationManager {
    
    func popToWorkoutsScreenAnimated(animated: Bool) {
        navigationController.popToRootViewControllerAnimated(animated)
    }
    
    func pushWorkoutEditScreenFromWorkoutsScreenWithWorkout(workout: Workout?, animated: Bool, workoutDidEditAction: ((workout: Workout) -> ())?) {
        let screen = storyboard.instantiateViewControllerWithIdentifier(WorkoutEditScreen.className()) as! WorkoutEditScreen
        screen.workout = workout
        screen.workoutDidEditAction = workoutDidEditAction
        
        let screens = [navigationController.viewControllers[0], screen]
        navigationController.setViewControllers(screens, animated: animated)
    }
    
    func pushStepEditScreenFromCurrentScreenWithStep(step: Step?, animated: Bool, stepDidEditAction: ((step: Step) -> ())?) {
        let screen = storyboard.instantiateViewControllerWithIdentifier(StepEditScreen.className()) as! StepEditScreen
        screen.step = step
        screen.stepDidEditAction = stepDidEditAction
        
        navigationController.pushViewController(screen, animated: animated)
    }
}
