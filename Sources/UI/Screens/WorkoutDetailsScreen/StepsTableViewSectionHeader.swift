//
//  StepsTableViewSectionHeader.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/29/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class StepsTableViewSectionHeader: ExpandableTableViewSectionHeader {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    
    func fillWithStep(step: Step) {
        nameLabel.text = step.name
        durationLabel.attributedText = NSAttributedString.durationStringForStep(step,
            valueFont: UIFont.systemFontOfSize(22.0, weight: UIFontWeightLight),
            unitFont: UIFont.systemFontOfSize(10.0, weight: UIFontWeightLight),
            color: UIColor.primaryTextColor())
    }
}
