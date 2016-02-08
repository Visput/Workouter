//
//  NewStepTemplateCell.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/16/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class NewStepTemplateCell: ActionableCollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionVisualizationEnabled = false
        actionsEnabled = false
    }
}
