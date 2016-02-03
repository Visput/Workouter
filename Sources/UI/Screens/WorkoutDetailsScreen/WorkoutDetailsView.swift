//
//  WorkoutDetailsView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 10/31/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class WorkoutDetailsView: BaseScreenView {

    @IBOutlet private(set) weak var headerView: UserWorkoutCell!
    @IBOutlet private(set) weak var favoriteButton: TintButton!
    @IBOutlet private(set) weak var stepsTableView: ExpandableTableView!
    
    override func didLoad() {
        super.didLoad()
        headerView.actionsEnabled = false        
        stepsTableView.rowHeight = UITableViewAutomaticDimension
        stepsTableView.estimatedRowHeight = 80.0
    }
}
