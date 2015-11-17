//
//  StepCell.swift
//  Workouter
//
//  Created by Uladzimir Papko on 10/25/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class StepCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    
    func fillWithStep(step: Step) {
        nameLabel.text = step.name
        descriptionLabel.text = step.stepDescription
        durationLabel.attributedText = NSAttributedString.durationStringForStep(step,
            valueFont: UIFont.systemFontOfSize(21.0),
            unitFont: UIFont.systemFontOfSize(10))
    }
}
