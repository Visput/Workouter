//
//  UserWorkoutCell.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/5/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

final class UserWorkoutCell: ActionableCollectionViewCell {
    
    @IBOutlet private(set) weak var nameLabel: UILabel!
    @IBOutlet private(set) weak var descriptionLabel: UILabel!
    @IBOutlet private(set) weak var stepsCountLabel: UILabel!
    @IBOutlet private(set) weak var durationLabel: UILabel!
    
    @IBOutlet private(set) weak var deleteButton: UIButton!
    @IBOutlet private(set) weak var cloneButton: UIButton!
    @IBOutlet private(set) weak var moveButton: UIButton!
    
    private(set) var item: UserWorkoutCellItem?
    
    func fillWithItem(item: UserWorkoutCellItem) {
        self.item = item
        
        nameLabel.text = item.workout.name
        descriptionLabel.text = item.workout.muscleGroupsDescription
        
        withVaList([item.workout.steps.count]) { pointer in
            stepsCountLabel.vp_setAttributedTextFormatArguments(pointer, keepFormat: true)
        }
        
        durationLabel.attributedText = NSAttributedString.durationStringForWorkout(item.workout,
            valueFont: UIFont.systemFontOfSize(14.0, weight: UIFontWeightRegular),
            unitFont: UIFont.systemFontOfSize(12.0, weight: UIFontWeightRegular),
            color: UIColor.secondaryTextColor())
    }
}
