//
//  WorkoutEditScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/29/14.
//  Copyright (c) 2014 visput. All rights reserved.
//

import UIKit

class WorkoutEditScreen: BaseScreen {
    
    var workoutDidEditAction: ((workout: Workout) -> ())?
    
    var workout: Workout = Workout.emptyWorkout() {
        didSet {
            guard isViewLoaded() else { return }
            fillViewWithWorkout(workout)
        }
    }
    
    private var descriptionController: TextViewController!
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
            nameController.placeholder = NSLocalizedString("Name", comment: "")
            nameController.didChangeTextAction = { [unowned self] text in
                self.workout = self.workout.workoutBySettingName(text)
            }
            
        } else if segue.identifier! == "WorkoutDescription" {
            descriptionController = segue.destinationViewController as! TextViewController
            descriptionController.placeholder = NSLocalizedString("Description (Optional)", comment: "")
            descriptionController.didChangeTextAction = { [unowned self] text in
                self.workout = self.workout.workoutBySettingDescription(text)
            }
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
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            
            if editingStyle == .Delete {
                needsReloadStepsTableView = false
                workout = workout.workoutByRemovingStepAtIndex(indexPath.row);
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
        navigationManager.pushStepEditScreenFromCurrentScreenWithStep(step, animated: true) { [unowned self] step in
            self.workout = self.workout.workoutByReplacingStepAtIndex(stepIndex, withStep: step)
            self.navigationManager.popScreenAnimated(true)
        }
    }
}

extension WorkoutEditScreen {
    
    @IBAction private func doneButtonDidPress(sender: AnyObject) {
        workoutDidEditAction?(workout: workout)
    }
    
    @IBAction private func addStepButtonDidPress(sender: AnyObject) {
        let searchRequest = StepsSearchRequest(workout: workout, searchText: "")
        
        navigationManager.presentStepTemplatesScreenWithRequest(searchRequest,
            animated: true,
            templateDidSelectAction: { [unowned self] step in
                
                self.navigationManager.pushStepEditScreenFromCurrentScreenWithStep(step, animated: false) { step in
                    self.workout = self.workout.workoutByAddingStep(step)
                    self.navigationManager.popScreenAnimated(true)
                }
                self.navigationManager.dismissScreenAnimated(true)
                
            }, templateDidCancelAction: { () -> () in
                self.navigationManager.dismissScreenAnimated(true)
        })
    }
}

extension WorkoutEditScreen {
    
    private func fillViewWithWorkout(workout: Workout) {
        nameController.text = workout.name
        nameController.textMaxLength = workout.nameMaxLength
        descriptionController.text = workout.workoutDescription
        descriptionController.textMaxLength = workout.descriptionMaxLength
        
        if workout.isEmpty() {
            nameController.active = true
        }
        
        if needsReloadStepsTableView {
            workoutEditView.stepsTableView.reloadData()
        }
        needsReloadStepsTableView = true
    }
}
