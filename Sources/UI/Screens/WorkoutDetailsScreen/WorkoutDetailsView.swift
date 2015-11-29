//
//  WorkoutDetailsView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 10/31/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class WorkoutDetailsView: BaseScreenView {

    @IBOutlet private(set) weak var nameLabel: UILabel!
    @IBOutlet private(set) weak var descriptionLabel: UILabel!
    @IBOutlet private(set) weak var stepsTableView: ExpandableTableView!
    
    override func didLoad() {
        super.didLoad()
        stepsTableView.rowHeight = UITableViewAutomaticDimension
        stepsTableView.estimatedRowHeight = 80.0
    }
}
