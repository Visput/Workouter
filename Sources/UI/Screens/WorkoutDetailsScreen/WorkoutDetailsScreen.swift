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
    
    private var expandedStepIndex: Int?
    
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

extension WorkoutDetailsScreen: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            
            return workout.steps.count
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(StepDetailsCell.className(),
                forIndexPath: indexPath) as! StepDetailsCell
            
            let step = workout.steps[indexPath.item]
            cell.fillWithStep(step)
            
            cell.didSelectAction = { [unowned self] in
                //self.workoutDetailsView.switchExpandingStateForStepCellAtIndexPath(indexPath)
                
                if self.expandedStepIndex == indexPath.item {
                    self.expandedStepIndex = nil
                } else {
                    self.expandedStepIndex = indexPath.item
                }

                // Expand / Collapse cell.
                collectionView.performBatchUpdates(nil, completion: nil)
                if self.expandedStepIndex != nil {
                    collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
                }
            }
            
            return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            var cellHeight: CGFloat = 80.0
            if expandedStepIndex == indexPath.item {
                cellHeight = collectionView.bounds.size.height
            }
            return CGSizeMake(collectionView.frame.size.width, cellHeight)
    }
}

extension WorkoutDetailsScreen {
    
    @IBAction private func startWorkoutButtonDidPress(sender: AnyObject) {
        navigationManager.pushWorkoutPlayerScreenWithWorkout(workout, animated: true)
    }
    
    @IBAction private func favoriteButtonDidPress(sender: AnyObject) {
        workoutsProvider.addWorkout(workout.clone())
        UIView.animateWithDefaultDuration {
            self.workoutDetailsView.favoriteButton.hidden = true
        }
    }
    
    @objc private func editWorkoutButtonDidPress(sender: AnyObject) {
        navigationManager.presentWorkoutEditScreenWithWorkout(workout,
            animated: true,
            workoutDidEditAction: { [unowned self] workout in
                self.workoutsProvider.updateWorkout(self.workout, withWorkout: workout)
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
        workoutDetailsView.headerView.fillWithWorkout(workout)
        workoutDetailsView.stepsCollectionView.reloadData()
        workoutDetailsView.favoriteButton.hidden = workoutsProvider.containsWorkout(workout)
    }
}
