//
//  WorkoutsScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/28/14.
//  Copyright (c) 2014 visput. All rights reserved.
//

import UIKit

class WorkoutsScreen: BaseScreen, UITableViewDelegate, UITableViewDataSource {
    
    private var workoutsProvider: WorkoutsProvider {
        return modelProvider.workoutsProvider
    }
    
    private var workoutsView: WorkoutsView {
        return view as! WorkoutsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        workoutsProvider.loadWorkouts()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutsProvider.workouts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WorkoutCell") as! WorkoutCell
        cell.fillWithWorkout(workoutsProvider.workouts[indexPath.row])
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
            workoutsProvider.deleteWorkoutAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
        }
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        workoutsProvider.moveWorkoutFromIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    @IBAction private func onModeButtonPressed(sender: UIBarButtonItem) {
        switch workoutsView.mode {
        case .Standard:
            workoutsView.applyEditMode()
        case .Edit:
            workoutsView.applyStandardMode()
        }
    }
}