//
//  StepDetailsCell.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/28/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class StepDetailsCell: ActionableCollectionViewCell {

    @IBOutlet private(set) weak var nameLabel: UILabel!
    @IBOutlet private(set) weak var indexLabel: UILabel!
    
    func fillWithItem(item: StepDetailsCellItem) {
        nameLabel.text = item.step.name
        indexLabel.text = String(item.index)
    }
}
