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
        navigationManager.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationManager.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.AllButUpsideDown
    }
}

extension WorkoutPlayerScreen: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return workout.steps.count
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100.0
    }
}

extension WorkoutPlayerScreen {
    
    @IBAction private func cancelButtonDidPress(sender: AnyObject) {
        navigationManager.popScreenAnimated(true)
        
    }
    
    @IBAction private func pauseButtonDidPress(sender: AnyObject) {
        workoutPlayerView.progressView.setProgress(200.0, animated: true)
    }
}

extension WorkoutPlayerScreen {
    
    private func fillViewWithWorkout(workout: Workout) {
        workoutPlayerView.progressView.progressItems = progressItemsFromSteps(workout.steps)
    }
    
    private func progressItemsFromSteps(steps: [Step]) -> [ProgressViewItem] {
        var progressItems = [ProgressViewItem]()
        for step in steps {
            var progressItem: ProgressViewItem! = nil
            switch step.type {
            case .Exercise:
                progressItem = ProgressViewItem(trackTintColor: UIColor.lightSecondaryColor(),
                    progressTintColor: UIColor.secondaryColor(),
                    progress: CGFloat(step.duration))
            case .Rest:
                progressItem = ProgressViewItem(trackTintColor: UIColor.lightPrimaryColor(),
                    progressTintColor: UIColor.primaryColor(),
                    progress: CGFloat(step.duration))
            }
            
            progressItems.append(progressItem)
        }
        
        return progressItems
    }
}
