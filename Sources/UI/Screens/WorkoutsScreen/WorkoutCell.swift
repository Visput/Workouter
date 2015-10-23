//
//  WorkoutCell.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/21/15.
//  Copyright (c) 2015 visput. All rights reserved.
//

import UIKit

class WorkoutCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    
    func fillWithWorkout(workout: Workout) {
        nameLabel.text = workout.name
    }
}
