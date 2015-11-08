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
    
    func fillWithWorkout(workout: Workout) {
        if workout.isEmpty() {
            nameLabel.text = NSLocalizedString("Empty Workout", comment: "")
        } else {
            nameLabel.text = workout.name
        }
    }
}
