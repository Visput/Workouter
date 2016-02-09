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
    
    /// Used for preventing multiple cells reordering.
    private var reorderingCellIndex: Int?
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

extension WorkoutEditScreen: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            
            return workout.steps.count
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(StepEditCell.className(),
                forIndexPath: indexPath) as! StepEditCell
            
            let item = StepEditCellItem(step: workout.steps[indexPath.item],
                index: indexPath.item + 1,
                actionButtonsTag: indexPath.item
            )
            cell.fillWithItem(item)
            cell.didSelectAction = { [unowned self] in
                self.workoutEditView.stepsCollectionView.switchExpandingStateForCellAtIndexPath(indexPath)
            }
            
            cell.deleteButton.addTarget(self, action: Selector("deleteStepButtonDidPress:"), forControlEvents: .TouchUpInside)
            cell.cloneButton.addTarget(self, action: Selector("cloneStepButtonDidPress:"), forControlEvents: .TouchUpInside)
            let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: "reorderStepButtonDidPress:")
            gestureRecognizer.minimumPressDuration = 0.1
            cell.reorderGestureRecognizer = gestureRecognizer
            
            return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        moveItemAtIndexPath sourceIndexPath: NSIndexPath,
        toIndexPath destinationIndexPath: NSIndexPath) {
            
            needsReloadStepsCollectionView = false
            workout = workout.workoutByMovingStepFromIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
            updateVisibleCells()
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            return workoutEditView.stepCellSizeAtIndexPath(indexPath)
    }
}

extension WorkoutEditScreen {
    
    @IBAction private func newStepButtonDidPress(sender: AnyObject) {
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
        workoutEditView.endEditing(true)
        if validateWorkout() {
            workoutDidEditAction?(workout: workout)
        }
    }
    
    @objc private func cancelButtonDidPress(sender: AnyObject) {
        workoutEditView.endEditing(true)
        workoutDidCancelAction?()
    }
    
    @objc private func deleteStepButtonDidPress(sender: UIButton) {
        let collectionView = workoutEditView.stepsCollectionView
        let indexPath = NSIndexPath(forItem: sender.tag, inSection: 0)
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! StepEditCell
        cell.actionsVisible = false
        
        collectionView.performBatchUpdates({
            self.needsReloadStepsCollectionView = false
            self.workout = self.workout.workoutByRemovingStepAtIndex(indexPath.row)
            collectionView.deleteItemsAtIndexPaths([indexPath])
            
            }, completion: { _ in
                // Reload data instead of updating buttons tags to prevent strange crashes (UICollectionView issue).
                collectionView.reloadData()
        })
    }
    
    @objc private func cloneStepButtonDidPress(sender: UIButton) {
        let collectionView = workoutEditView.stepsCollectionView
        let indexPath = NSIndexPath(forItem: sender.tag, inSection: 0)
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! StepEditCell
        cell.actionsVisible = false
        
        let newIndexPath = NSIndexPath(forItem: indexPath.item + 1, inSection: indexPath.section)
        let step = cell.item!.step
        let clonedStep = step.clone()
        
        collectionView.performBatchUpdates({
            self.needsReloadStepsCollectionView = false
            self.workout = self.workout.workoutByAddingStep(clonedStep, atIndex: newIndexPath.item)
            collectionView.insertItemsAtIndexPaths([newIndexPath])
            
            }, completion: { _ in
                // Scroll to show cell with cloned workout.
                collectionView.scrollToCellAtIndexPath(newIndexPath, animated: true)
                self.updateVisibleCells()
        })
    }
    
    @objc private func reorderStepButtonDidPress(gesture: UILongPressGestureRecognizer) {
        let collectionView = workoutEditView.stepsCollectionView
        let indexPath = NSIndexPath(forItem: gesture.view!.tag, inSection: 0)
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? StepEditCell else { return }
        
        if reorderingCellIndex == nil || reorderingCellIndex! == indexPath.item {
            var targetLocation = collectionView.convertPoint(gesture.locationInView(cell.reorderButton), fromView: cell.reorderButton)
            targetLocation.x = collectionView.bounds.size.width / 2.0
            
            switch(gesture.state) {
                
            case .Began:
                collectionView.springFlowLayout.springBehaviorEnabled = false
                reorderingCellIndex = indexPath.item
                collectionView.beginInteractiveMovementForItemAtIndexPath(indexPath)
                collectionView.updateInteractiveMovementTargetPosition(targetLocation)
                cell.applyReorderingInProgressAppearance()
                
            case .Changed:
                collectionView.updateInteractiveMovementTargetPosition(targetLocation)
                updateVisibleCellsButtonsTags()
                // Update cell index after movement.
                reorderingCellIndex = gesture.view!.tag
                
            case .Ended:
                collectionView.endInteractiveMovement()
                updateVisibleCells()
                cell.actionsVisible = false
                reorderingCellIndex = nil
                collectionView.springFlowLayout.springBehaviorEnabled = true
                
            default:
                collectionView.cancelInteractiveMovement()
                updateVisibleCells()
                cell.actionsVisible = false
                reorderingCellIndex = nil
                collectionView.springFlowLayout.springBehaviorEnabled = true
            }
        } else {
            cell.actionsVisible = false
        }
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
    
    private func updateVisibleCells() {
        for cell in workoutEditView.stepsCollectionView.visibleCells() as! [StepEditCell] {
            let indexPath = workoutEditView.stepsCollectionView.indexPathForCell(cell)!
            let item = StepEditCellItem(step: workout.steps[indexPath.item],
                index: indexPath.item + 1,
                actionButtonsTag: indexPath.item
            )
            cell.fillWithItem(item)
        }
    }
    
    private func updateVisibleCellsButtonsTags() {
        for cell in workoutEditView.stepsCollectionView.visibleCells() as! [StepEditCell] {
            let index = workoutEditView.stepsCollectionView.indexPathForCell(cell)!.row
            cell.setActionButtonsTag(index)
        }
    }
}
