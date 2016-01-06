//
//  StepDetailsCell.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/28/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class StepDetailsCell: BaseTableViewCell {

    @IBOutlet private weak var descriptionLabel: UILabel!
    
    func fillWithStep(step: Step) {
        descriptionLabel.text = step.stepDescription
    }
}
