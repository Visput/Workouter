//
//  WorkoutEditScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/29/14.
//  Copyright (c) 2014 visput. All rights reserved.
//

import UIKit

final class WorkoutEditScreen: BaseScreen {
    
    var workoutDidEditAction: ((workout: Workout) -> Void)?
    var workoutDidCancelAction: (() -> Void)?
    
    var workout: Workout! {
        didSet {
            guard isViewLoaded() else { return }
            fillViewWithWorkout(workout)
        }
    }
    
    var showWorkoutDetailsOnCompletion: Bool = false
    
    private var nameController: TextViewController!
    private var needsReloadStepsTableView = true
    
    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
    
    private var workoutEditView: WorkoutEditView {
        return view as! WorkoutEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillViewWithWorkout(workout)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "WorkoutName" {
            nameController = segue.destinationViewController as! TextViewController
            configureNameController()
        }
    }
}

extension WorkoutEditScreen: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout.steps.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StepCell.className()) as! StepCell
        let step = workout.steps[indexPath.row]
        cell.fillWithStep(step)
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            
            if editingStyle == .Delete {
                needsReloadStepsTableView = false
                workout = workout.workoutByRemovingStepAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            }
    }
    
    func tableView(tableView: UITableView,
        moveRowAtIndexPath sourceIndexPath: NSIndexPath,
        toIndexPath destinationIndexPath: NSIndexPath) {
            
            needsReloadStepsTableView = false
            workout = workout.workoutByMovingStepFromIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let stepIndex = indexPath.row
        let step = workout.steps[stepIndex]
        navigationManager.presentStepEditScreenWithStep(step,
            animated: true,
            stepDidEditAction: { [unowned self] step in
                
                self.workout = self.workout.workoutByReplacingStepAtIndex(stepIndex, withStep: step)
                self.navigationManager.dismissScreenAnimated(true)
                
            }, stepDidCancelAction: { [unowned self] in
                self.navigationManager.dismissScreenAnimated(true)
            })
    }
}

extension WorkoutEditScreen {
    
    @IBAction private func newStepButtonDidPress(sender: AnyObject) {
        let searchRequest = StepsSearchRequest(workout: workout, searchText: "")
        
        navigationManager.presentStepTemplatesScreenWithRequest(searchRequest,
            animated: true,
            templateDidSelectAction: { [unowned self] step in
                
                self.navigationManager.pushStepEditScreenWithStep(step,
                    animated: true,
                    stepDidEditAction: { step in
                        
                        self.workout = self.workout.workoutByAddingStep(step)
                        self.workoutEditView.doneButton.hidden = false
                        self.navigationManager.dismissScreenAnimated(true)
                })
                
            }, templateDidCancelAction: {
                self.navigationManager.dismissScreenAnimated(true)
        })
    }
    
    @IBAction private func doneButtonDidPress(sender: AnyObject) {
        workoutEditView.endEditing(true)
        if validateWorkout() {
            workoutDidEditAction?(workout: workout)
        }
    }
    
    @objc private func cancelButtonDidPress(sender: AnyObject) {
        workoutEditView.endEditing(true)
        workoutDidCancelAction?()
    }
}

extension WorkoutEditScreen {
    
    override func configureBarButtonItems() {
        super.configureBarButtonItems()
        navigationItem.leftBarButtonItem = UIBarButtonItem.greenCancelItemWithAlignment(.Left,
            target: self,
            action: Selector("cancelButtonDidPress:"))
    }
    
    private func fillViewWithWorkout(workout: Workout) {
        if workout.isEmpty() {
            title = NSLocalizedString("New Workout", comment: "")
        } else {
            title = NSLocalizedString("Edit Workout", comment: "")
        }
        
        nameController.text = workout.name
        nameController.textMaxLength = workout.nameMaxLength
        
        if needsReloadStepsTableView {
            workoutEditView.stepsTableView.reloadData()
        }
        needsReloadStepsTableView = true
        
        workoutEditView.doneButton.hidden = workout.steps.count == 0
    }
    
    private func configureNameController() {
        nameController.placeholder = NSLocalizedString("Name", comment: "")
        nameController.descriptionTitle = NSLocalizedString("Workout Name", comment: "")
        nameController.descriptionMessage = NSLocalizedString("Workout name is short description of your workout.", comment: "")
        nameController.didChangeTextAction = { [unowned self] text in
            self.workout = self.workout.workoutBySettingName(text)
            self.nameController.setValid()
        }
    }
    
    private func validateWorkout() -> Bool {
        if workout.name.isEmpty {
            nameController.setInvalidWithErrorTitle(NSLocalizedString("Error", comment: ""),
                errorMessage: NSLocalizedString("Workout name is required field.", comment: ""))
        } else {
            nameController.setValid()
        }
    
        return nameController.valid
    }
}
