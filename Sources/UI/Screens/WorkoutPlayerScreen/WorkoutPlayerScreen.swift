//
//  WorkoutPlayerScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/25/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class WorkoutPlayerScreen: BaseScreen {
    
    var workout: Workout! {
        willSet (newWorkout) {
            guard workout != nil && workout != newWorkout else {
                fatalError("Workout can be set only once per screen lifecycle.")
            }
        }
    }
    
    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
    
    private var workoutPlayerView: WorkoutPlayerView {
        return view as! WorkoutPlayerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationManager.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationManager.setNavigationBarHidden(false, animated: animated)
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.AllButUpsideDown
    }
}

extension WorkoutPlayerScreen {
    
    @IBAction private func closeButtonDidPress(sender: AnyObject) {
        navigationManager.popScreenAnimated(true)
    }
}
