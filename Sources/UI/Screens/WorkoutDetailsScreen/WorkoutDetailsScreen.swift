//
//  WorkoutDetailsScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/28/14.
//  Copyright (c) 2014 visput. All rights reserved.
//

import UIKit

final class WorkoutDetailsScreen: BaseScreen {
    
    var workout: Workout! {
        didSet {
            guard isViewLoaded() else { return }
            fillViewWithWorkout(workout)
        }
    }
    
    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
    
    private var workoutsProvider: WorkoutsProvider {
        return modelProvider.workoutsProvider
    }
    
    private var workoutDetailsView: WorkoutDetailsView {
        return view as! WorkoutDetailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workoutDetailsView.stepsTableView.delegate = self
        workoutDetailsView.stepsTableView.dataSource = self
        
        fillViewWithWorkout(workout)
    }
}

extension WorkoutDetailsScreen: ExpandableTableViewDelegate, ExpandableTableViewDataSource {
    
    func numberOfSectionsInExpandableTableView(tableView: ExpandableTableView) -> Int {
        return workout.steps.count
    }
    
    func expandableTableView(tableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        let step = workout.steps[section]
        
        return step.stepDescription.isEmpty ? 0 : 1
    }
    
    func expandableTableView(tableView: ExpandableTableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let step = workout.steps[indexPath.section]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(StepDetailsCell.className()) as! StepDetailsCell
        cell.fillWithStep(step)
        
        return cell
    }
    
    func expandableTableView(tableView: ExpandableTableView, sectionHeaderAtIndex section: Int) -> ExpandableTableViewSectionHeader {
        let step = workout.steps[section]
        
        let header = NSBundle.mainBundle().loadNibNamed(StepsTableViewSectionHeader.className(),
            owner: nil,
            options: nil).last as! StepsTableViewSectionHeader
        header.frame.size.width = tableView.frame.size.width
        
        header.fillWithStep(step)
        header.sizeToFit()
        
        return header
    }
}

extension WorkoutDetailsScreen {
    
    @IBAction private func startWorkoutButtonDidPress(sender: AnyObject) {
        navigationManager.pushWorkoutPlayerScreenWithWorkout(workout, animated: true)
    }
    
    @objc private func editWorkoutButtonDidPress(sender: AnyObject) {
        navigationManager.presentWorkoutEditScreenWithWorkout(workout,
            animated: true,
            workoutDidEditAction: { [unowned self] workout in
                self.workoutsProvider.replaceWorkout(self.workout, withWorkout: workout)
                self.workout = workout
                self.navigationManager.dismissScreenAnimated(true)
            }, workoutDidCancelAction: { [unowned self] in
                self.navigationManager.dismissScreenAnimated(true)
            })
    }
}

extension WorkoutDetailsScreen {
    
    override func configureBarButtonItems() {
        super.configureBarButtonItems()
        navigationItem.rightBarButtonItem = UIBarButtonItem.greenEditItemWithAlignment(.Right,
            target: self,
            action: Selector("editWorkoutButtonDidPress:"))
    }
    
    private func fillViewWithWorkout(workout: Workout) {
        workoutDetailsView.nameLabel.text = workout.name
        workoutDetailsView.descriptionLabel.text = workout.workoutDescription
        workoutDetailsView.stepsTableView.reloadData()
    }
}
