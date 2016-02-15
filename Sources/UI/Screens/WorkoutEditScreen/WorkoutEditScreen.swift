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
    private var stepsPlaceholderController: PlaceholderController!

    private var needsReloadStepsCollectionView = true
    
    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
    
    private var workoutEditView: WorkoutEditView {
        return view as! WorkoutEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if workout.isEmpty() {
            title = NSLocalizedString("New Workout", comment: "")
        } else {
            title = NSLocalizedString("Edit Workout", comment: "")
        }
        
        fillViewWithWorkout(workout)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "WorkoutName" {
            nameController = segue.destinationViewController as! TextViewController
            configureNameController()
        } else if segue.identifier! == "StepsPlaceholder" {
            stepsPlaceholderController = segue.destinationViewController as! PlaceholderController
        }
    }
}

extension WorkoutEditScreen: ActionableCollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            
            return workout.steps.count
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(StepEditCell.className(),
                forIndexPath: indexPath) as! StepEditCell
            
            let item = StepEditCellItem(step: workout.steps[indexPath.item],
                index: indexPath.item + 1
            )
            cell.fillWithItem(item)
            
            return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            return workoutEditView.stepCellSizeAtIndexPath(indexPath)
    }
    
    func collectionView(collectionView: ActionableCollectionView,
        canExpandCellAtIndexPath indexPath: NSIndexPath) -> Bool {
            
            return true
    }
    
    func collectionView(collectionView: ActionableCollectionView,
        canShowActionsForCellAtIndexPath indexPath: NSIndexPath) -> Bool {
            
            return true
    }
    
    func collectionView(collectionView: ActionableCollectionView,
        actionsForCell cell: ActionableCollectionViewCell,
        atIndexPath indexPath: NSIndexPath) -> [CollectionViewCellAction] {
            
            let currentCell = cell as! StepEditCell
            var actions = [CollectionViewCellAction]()
            actions.append(CollectionViewCellAction(type: .Delete, control: currentCell.deleteButton))
            actions.append(CollectionViewCellAction(type: .Clone, control: currentCell.cloneButton))
            actions.append(CollectionViewCellAction(type: .Move, control: currentCell.moveButton))
            
            return actions
    }
    
    func collectionView(collectionView: ActionableCollectionView,
        didSelectDeleteAction deleteAction: CollectionViewCellAction,
        forCellAtIndexPath deletedIndexPath: NSIndexPath) {
            
            needsReloadStepsCollectionView = false
            workout = workout.workoutByRemovingStepAtIndex(deletedIndexPath.row)
    }
    
    func collectionView(collectionView: ActionableCollectionView,
        didSelectCloneAction cloneAction: CollectionViewCellAction,
        forCellAtIndexPath sourceIndexPath: NSIndexPath,
        cloneIndexPath: NSIndexPath) {
    
            let cell = collectionView.cellForItemAtIndexPath(sourceIndexPath) as! StepEditCell
            let step = cell.item!.step
            let clonedStep = step.clone()
            needsReloadStepsCollectionView = false
            workout = workout.workoutByAddingStep(clonedStep, atIndex: cloneIndexPath.item)
    }
    
    func collectionView(collectionView: UICollectionView,
        moveItemAtIndexPath sourceIndexPath: NSIndexPath,
        toIndexPath destinationIndexPath: NSIndexPath) {
            
            needsReloadStepsCollectionView = false
            workout = workout.workoutByMovingStepFromIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    func collectionView(collectionView: ActionableCollectionView,
        didCompleteAction action: CollectionViewCellAction,
        forCellAtIndexPath indexPath: NSIndexPath) {
            
            // Update visible cells.
            for cell in workoutEditView.stepsCollectionView.visibleCells() as! [StepEditCell] {
                let indexPath = workoutEditView.stepsCollectionView.indexPathForCell(cell)!
                let item = StepEditCellItem(step: workout.steps[indexPath.item],
                    index: indexPath.item + 1
                )
                cell.fillWithItem(item)
            }
    }
}

extension WorkoutEditScreen {
    
    @IBAction private func newStepButtonDidPress(sender: AnyObject) {
        workoutEditView.stepsCollectionView.hideCellsActionsAnimated(true)
        
        navigationManager.presentMuscleGroupsScreenAnimated(true,
            muscleGroupsDidSelectAction: { [unowned self] muscleGroup in
                
                let searchRequest = StepsSearchRequest(workout: self.workout, muscleGroup: muscleGroup, searchText: "")
                self.navigationManager.pushStepTemplatesScreenWithRequest(searchRequest,
                    animated: true,
                    templateDidSelectAction: { [unowned self] step in
                        
                        self.navigationManager.pushStepEditScreenWithStep(step,
                            animated: true,
                            stepDidEditAction: { [unowned self] step in
                                
                                self.workout = self.workout.workoutByAddingStep(step)
                                self.workoutEditView.doneButton.hidden = false
                                self.navigationManager.dismissScreenAnimated(true)
                        })
                    })
                
            }, muscleGroupsDidCancelAction: { [unowned self] in
                self.navigationManager.dismissScreenAnimated(true)
        })
    }
    
    @IBAction private func doneButtonDidPress(sender: AnyObject) {
        workoutEditView.stepsCollectionView.hideCellsActionsAnimated(true)
            
        workoutEditView.endEditing(true)
        if validateWorkout() {
            workoutDidEditAction?(workout: workout)
        }
    }
    
    @objc private func cancelButtonDidPress(sender: AnyObject) {
        workoutEditView.stepsCollectionView.hideCellsActionsAnimated(true)
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
        nameController.text = workout.name
        nameController.textMaxLength = workout.nameMaxLength
        
        if needsReloadStepsCollectionView {
            workoutEditView.stepsCollectionView.reloadData()
        }
        needsReloadStepsCollectionView = true
        
        UIView.animateWithDefaultDuration {
            self.workoutEditView.doneButton.hidden = workout.steps.count == 0
        }
        
        stepsPlaceholderController.setVisible(workout.steps.count == 0, animated: true)
    }
    
    private func configureNameController() {
        nameController.placeholder = NSLocalizedString("Name", comment: "")
        nameController.descriptionTitle = NSLocalizedString("Workout Name", comment: "")
        nameController.descriptionMessage = NSLocalizedString("Workout name is short description of your workout.", comment: "")
        nameController.didChangeTextAction = { [unowned self] text in
            self.needsReloadStepsCollectionView = false
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
