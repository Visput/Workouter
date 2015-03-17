//
//  WorkoutCell.swift
//  SportTime
//
//  Created by Vladimir Popko on 1/21/15.
//  Copyright (c) 2015 visput. All rights reserved.
//

import UIKit

class WorkoutCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    
    func fill(#workout: Workout) {
        self.nameLabel.text = workout.name
    }
}
