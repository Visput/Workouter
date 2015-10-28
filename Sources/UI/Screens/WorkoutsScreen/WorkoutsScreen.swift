//
//  WorkoutsScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/28/14.
//  Copyright (c) 2014 visput. All rights reserved.
//

import UIKit

class WorkoutsScreen: BaseScreen {
    
    private var workoutsProvider: WorkoutsProvider {
        return modelProvider.workoutsProvider
    }
    
    private var screenManger: ScreenManager {
        return modelProvider.screenManager
    }
    
    private var workoutsView: WorkoutsView {
        return view as! WorkoutsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        workoutsProvider.loadWorkouts()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        workoutsView.mode = .Standard
    }
}

extension WorkoutsScreen: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutsProvider.workouts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(WorkoutCell.className()) as! WorkoutCell
        let workout = workoutsProvider.workouts[indexPath.row]
        cell.fillWithWorkout(workout)
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return workoutsView.mode == .Edit
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return workoutsView.mode == .Edit
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            workoutsProvider.removeWorkoutAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
        }
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        workoutsProvider.moveWorkoutFromIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let workout = workoutsProvider.workouts[indexPath.row]
        
        if workoutsView.mode == .Edit {
            screenManger.pushWorkoutEditScreenFromWorkoutsScreenWithWorkout(workout) { [unowned self] workout in
                self.workoutsProvider.replaceWorkoutAtIndex(indexPath.row, withWorkout: workout)
                self.workoutsView.workoutsTableView.reloadData()
            }
            
        } else {
            screenManger.pushWorkoutDetailsScreenFromCurrentScreenWithWorkout(workout)
        }
    }
}

extension WorkoutsScreen {
    
    @IBAction private func modeButtonDidPress(sender: UIBarButtonItem) {
        switch workoutsView.mode {
        case .Standard:
            workoutsView.applyEditMode()
        case .Edit:
            workoutsView.applyStandardMode()
        }
    }
    
    @IBAction private func newWorkoutButtonDidPress(sender: UIBarButtonItem) {
        screenManger.pushWorkoutEditScreenFromWorkoutsScreenWithWorkout(nil) { [unowned self] workout in
            self.workoutsProvider.addWorkout(workout)
            self.workoutsView.workoutsTableView.reloadData()
        }
    }
}