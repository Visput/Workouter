//
//  WorkoutTemplateCell.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/3/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class WorkoutTemplateCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var stepsCountLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    
    func fillWithWorkout(workout: Workout) {
        nameLabel.text = workout.name
        descriptionLabel.text = workout.workoutDescription
        stepsCountLabel.text = String(workout.steps.count)
        
        durationLabel.attributedText = NSAttributedString.durationStringForWorkout(workout,
            valueFont: UIFont.systemFontOfSize(12.0, weight: UIFontWeightLight),
            unitFont: UIFont.systemFontOfSize(8, weight: UIFontWeightLight))
    }
}
