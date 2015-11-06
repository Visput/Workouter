//
//  StepTemplateCell.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/3/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class StepTemplateCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    
    func fillWithStep(step: Step) {
        if step.isEmpty() {
            nameLabel.text = NSLocalizedString("Empty Step", comment: nil)
        } else {
            nameLabel.text = step.name
        }
        
        descriptionLabel.text = step.stepDescription
    }
}
