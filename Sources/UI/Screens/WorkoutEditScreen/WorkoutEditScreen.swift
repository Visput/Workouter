//
//  WorkoutEditScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/29/14.
//  Copyright (c) 2014 visput. All rights reserved.
//

import UIKit

class WorkoutEditScreen: BaseScreen, UITableViewDelegate, UITableViewDataSource {
    
    var workoutDidEditAction: ((workout: Workout) -> ())?
    
    var workout = Workout.emptyWorkout() {
        didSet {
            if isViewLoaded() {
                fillViewWithWorkout(workout)
            }
        }
    }
    
    private var descriptionController: TextViewController!
    private var needsReloadStepsTableView = true
    
    private var workoutEditView: WorkoutEditView {
        return view as! WorkoutEditView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fillViewWithWorkout(workout)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "WorkoutDescription" {
            descriptionController = segue.destinationViewController as! TextViewController
            
        } else if segue.identifier! == "CreateStep" {
            let screen = segue.destinationViewController as! StepEditScreen
            
            screen.stepDidEditAction = { [unowned self] step in
                self.workout = self.workout.workoutByAddingStep(step)
            }
            
        } else if segue.identifier! == "EditStep" {
            let screen = segue.destinationViewController as! StepEditScreen
            let stepIndex = workoutEditView.stepsTableView.indexPathForSelectedRow!.row
            screen.step = workout.steps[stepIndex]
            
            screen.stepDidEditAction = { [unowned self] step in
                self.workout = self.workout.workoutByReplacingStepAtIndex(stepIndex, withStep: step)
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout.steps.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StepCell.className()) as! StepCell
        cell.fillWithStep(workout.steps[indexPath.row])
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
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            needsReloadStepsTableView = false
            workout = workout.workoutByRemovingStepAtIndex(indexPath.row);
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
        }
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        needsReloadStepsTableView = false
        workout = workout.workoutByMovingStepFromIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    @IBAction private func doneButtonDidPress(sender: AnyObject) {
        workoutDidEditAction?(workout: workout)

        let screen = self.storyboard!.instantiateViewControllerWithIdentifier(WorkoutDetailsScreen.className())
        navigationController?.popViewControllerAnimated(false)
        navigationController?.pushViewController(screen, animated: true)
    }
    
    private func fillViewWithWorkout(workout: Workout) {
        workoutEditView.nameField.text = workout.name
        descriptionController.textView.text = workout.workoutDescription
        
        if needsReloadStepsTableView {
            workoutEditView.stepsTableView.reloadData()
        }
        needsReloadStepsTableView = true
    }
}
