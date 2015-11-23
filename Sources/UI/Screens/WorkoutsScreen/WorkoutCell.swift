//
//  WorkoutCell.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/21/15.
//  Copyright (c) 2015 visput. All rights reserved.
//

import UIKit

final class WorkoutCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var stepsCountLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    
    func fillWithWorkout(workout: Workout) {
        nameLabel.text = workout.name
        descriptionLabel.text = workout.workoutDescription
        stepsCountLabel.text = String(workout.steps.count)
        
        durationLabel.attributedText = NSAttributedString.durationStringForWorkout(workout,
            valueFont: UIFont.systemFontOfSize(12.0),
            unitFont: UIFont.systemFontOfSize(8))
    }
}
