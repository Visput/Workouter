//
//  UserWorkoutCell.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/5/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

final class UserWorkoutCell: ActionableCollectionViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var stepsCountLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private(set) weak var cardView: UIView!
    
    @IBOutlet private(set) weak var deleteButton: UIButton!
    @IBOutlet private(set) weak var cloneButton: UIButton!
    @IBOutlet private(set) weak var reorderButton: UIButton!
    
    var reorderGestureRecognizer: UILongPressGestureRecognizer? {
        willSet {
            guard reorderGestureRecognizer != nil else { return }
            reorderButton.removeGestureRecognizer(reorderGestureRecognizer!)
        }
        
        didSet {
            guard reorderGestureRecognizer != nil else { return }
            reorderButton.addGestureRecognizer(reorderGestureRecognizer!)
        }
    }
    
    override var actionsVisible: Bool {
        didSet {
            if !actionsVisible {
                cardView.layer.borderWidth = 0.0
                cardView.layer.borderColor = UIColor.clearColor().CGColor
            }
        }
    }
    
    private(set) var workout: Workout?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        deleteButton.exclusiveTouch = true
        cloneButton.exclusiveTouch = true
        reorderButton.exclusiveTouch = true
        scrollView.exclusiveTouch = true
    }
    
    func fillWithWorkout(workout: Workout) {
        self.workout = workout
        
        nameLabel.text = workout.name
        descriptionLabel.text = workout.workoutDescription
        
        withVaList([workout.steps.count]) { pointer in
            stepsCountLabel.vp_setAttributedTextFormatArguments(pointer, keepFormat: true)
        }
        
        durationLabel.attributedText = NSAttributedString.durationStringForWorkout(workout,
            valueFont: UIFont.systemFontOfSize(14.0, weight: UIFontWeightRegular),
            unitFont: UIFont.systemFontOfSize(12.0, weight: UIFontWeightRegular),
            color: UIColor.secondaryTextColor())
    }
    
    func applyReorderingInProgressAppearance() {
        cardView.layer.borderWidth = 1.0
        cardView.layer.borderColor = reorderButton.backgroundColor!.CGColor
        setActionsOverlayOffset(reorderButton.bounds.size.width)
    }
}
