//
//  WorkoutPlayerScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/25/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit
import SceneKit

final class WorkoutPlayerScreen: BaseScreen {
    
    var workout: Workout! {
        willSet (newWorkout) {
            guard workout == nil || workout == newWorkout else {
                fatalError("Workout can be set only once per screen lifecycle.")
            }
        }
        didSet {
            guard isViewLoaded() else { return }
            fillViewWithWorkout(workout)
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
        fillViewWithWorkout(workout)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController!.setNavigationBarHidden(true, animated: animated)
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.AllButUpsideDown
    }
}

extension WorkoutPlayerScreen {
    
    @IBAction private func cancelButtonDidPress(sender: AnyObject) {
        navigationManager.popScreenAnimated(true)
        
    }
    
    @IBAction private func pauseButtonDidPress(sender: AnyObject) {
        workoutPlayerView.progressView.setProgress(200.0, animated: true)
    }
    
    @IBAction private func completeButtonDidPress(sender: AnyObject) {
        navigationManager.pushWorkoutCompletionScreenFromMainScreenWithWorkout(workout, animated: true)
    }
}

extension WorkoutPlayerScreen {
    
    private func fillViewWithWorkout(workout: Workout) {
        let animationScene = SCNScene(named: "Male.scnassets/PRG_7EN_01_001_001_Jumping_Jacks_SL_1_Select_1.dae")
        workoutPlayerView.exerciseSceneView.scene!.rootNode.addChildNode(animationScene!.rootNode)
        workoutPlayerView.progressView.progressItems = progressItemsFromSteps(workout.steps)
    }
    
    private func progressItemsFromSteps(steps: [Step]) -> [ProgressViewItem] {
        var progressItems = [ProgressViewItem]()
        for step in steps {
            progressItems.append(ProgressViewItem(trackTintColor: UIColor.lightPrimaryColor(),
                progressTintColor: UIColor.primaryColor(),
                progress: CGFloat(step.durationGoal!)))
            
            progressItems.append(ProgressViewItem(trackTintColor: UIColor.lightSecondaryColor(),
                progressTintColor: UIColor.secondaryColor(),
                progress: CGFloat(step.rest)))
        }
        
        return progressItems
    }
}
