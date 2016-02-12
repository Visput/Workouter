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
    
    private var needsReloadSteps = true
    
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
        fillViewWithWorkout(workout)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension WorkoutDetailsScreen: ActionableCollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            
            return workout.steps.count
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(StepDetailsCell.className(),
                forIndexPath: indexPath) as! StepDetailsCell
            
            let item = StepDetailsCellItem(step: workout.steps[indexPath.item], index: indexPath.item + 1)
            cell.fillWithItem(item)
            
            return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            return workoutDetailsView.templateCellSizeAtIndexPath(indexPath)
    }
}

extension WorkoutDetailsScreen {
    
    @IBAction private func startWorkoutButtonDidPress(sender: AnyObject) {
        navigationManager.pushWorkoutPlayerScreenWithWorkout(workout, animated: true)
    }
    
    @IBAction private func favoriteButtonDidPress(sender: AnyObject) {
        saveWorkout()
    }
    
    @objc private func editWorkoutButtonDidPress(sender: AnyObject) {
        let editAction = { [unowned self] in
            self.navigationManager.presentWorkoutEditScreenWithWorkout(self.workout,
                animated: true,
                workoutDidEditAction: { workout in
                    self.workoutsProvider.updateUserWorkout(self.workout, withWorkout: workout)
                    self.workout = workout
                    self.navigationManager.dismissScreenAnimated(true)
                }, workoutDidCancelAction: {
                    self.navigationManager.dismissScreenAnimated(true)
                })
        }
        
        if let userWorkout = workoutsProvider.userWorkoutForWorkout(workout) {
            // Edit user workout instead of default workout.
            self.workout = userWorkout
            editAction()
            
        } else {
            navigationManager.showTextDialogWithStyle(TextDialogFactory.Save,
                title: NSLocalizedString("Save Workout", comment: ""),
                message: NSLocalizedString("Built in workout has to be saved to My Workouts before edit.", comment: ""),
                confirmAction: { [unowned self] in
                    self.saveWorkout()
                    editAction()
            })
        }
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
        workoutDetailsView.descriptionLabel.text = workout.muscleGroupsDescription
        
        withVaList([workout.steps.count]) { pointer in
            workoutDetailsView.stepsCountLabel.vp_setAttributedTextFormatArguments(pointer, keepFormat: true)
        }
        
        workoutDetailsView.durationLabel.attributedText = NSAttributedString.durationStringForWorkout(workout,
            valueFont: UIFont.systemFontOfSize(14.0, weight: UIFontWeightRegular),
            unitFont: UIFont.systemFontOfSize(12.0, weight: UIFontWeightRegular),
            color: UIColor.secondaryTextColor())
        
        if needsReloadSteps {
            workoutDetailsView.stepsCollectionView.reloadData()
        }
        needsReloadSteps = true
        
        UIView.animateWithDefaultDuration {
            self.workoutDetailsView.favoriteButton.hidden = self.workoutsProvider.userWorkoutForWorkout(workout) != nil
        }
    }
    
    private func saveWorkout() {
        // Create user workout by cloning default workout.
        let userWorkout = workout.clone()
        workoutsProvider.addUserWorkout(userWorkout)
        // Prevent reloading of steps collection view to avoid cells blinking.
        needsReloadSteps = false
        workout = userWorkout
    }
}
