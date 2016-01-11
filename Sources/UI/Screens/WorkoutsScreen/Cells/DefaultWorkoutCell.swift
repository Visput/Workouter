//
//  DefaultWorkoutCell.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/21/15.
//  Copyright (c) 2015 visput. All rights reserved.
//

import UIKit

final class DefaultWorkoutCell: ActionableCollectionViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var stepsCountLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private(set) weak var cardView: UIView!
    
    @IBOutlet private(set) weak var favoriteButton: UIButton!
    
    private(set) var workout: Workout?
    
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
}
