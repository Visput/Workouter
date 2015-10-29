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
    
    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
    
    private var workoutsView: WorkoutsView {
        return view as! WorkoutsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        workoutsProvider.loadWorkouts()
        
        if traitCollection.forceTouchCapability == .Available {
            registerForPreviewingWithDelegate(self, sourceView: workoutsView.workoutsTableView)
        }
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
            navigationManager.pushWorkoutEditScreenFromWorkoutsScreenWithWorkout(workout, animated: true) { [unowned self] workout in
                self.workoutsProvider.replaceWorkoutAtIndex(indexPath.row, withWorkout: workout)
                self.workoutsView.workoutsTableView.reloadData()
            }
            
        } else {
            navigationManager.pushWorkoutDetailsScreenFromCurrentScreenWithWorkout(workout, animated: true)
        }
    }
}

extension WorkoutsScreen: UIViewControllerPreviewingDelegate {

    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {

        guard workoutsView.mode == .Standard,
            let indexPath = workoutsView.workoutsTableView.indexPathForRowAtPoint(location),
            let cell = workoutsView.workoutsTableView.cellForRowAtIndexPath(indexPath) else { return nil }
        
        previewingContext.sourceRect = cell.frame
        let workout = workoutsProvider.workouts[indexPath.row]
        let previewScreen = navigationManager.workoutDetailsScreenWithWorkout(workout)
        
        return previewScreen
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        navigationManager.pushScreen(viewControllerToCommit, animated: true)
    }
}

extension WorkoutsScreen {
    
    @IBAction private func modeButtonDidPress(sender: UIBarButtonItem) {
        workoutsView.switchMode()
    }
    
    @IBAction private func newWorkoutButtonDidPress(sender: UIBarButtonItem) {
        navigationManager.pushWorkoutEditScreenFromWorkoutsScreenWithWorkout(nil, animated: true) { [unowned self] workout in
            self.workoutsProvider.addWorkout(workout)
            self.workoutsView.workoutsTableView.reloadData()
        }
    }
}