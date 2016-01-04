//
//  WorkoutsView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 3/21/15.
//  Copyright (c) 2015 visput. All rights reserved.
//

import Foundation
import UIKit

final class WorkoutsView: BaseScreenView {
    
    @IBOutlet private(set) weak var workoutsTableView: UITableView!
    @IBOutlet private(set) weak var segmentedControl: UISegmentedControl!
    @IBOutlet private(set) weak var segmentedControlToolbar: UIToolbar!
    
    override func didLoad() {
        super.didLoad()
        workoutsTableView.rowHeight = UITableViewAutomaticDimension
        workoutsTableView.estimatedRowHeight = 100.0
        // Set clear background view to prevent setting view with gray color when search bar is added.
        workoutsTableView.backgroundView = UIView()
    }
    
    override func willAppear(animated: Bool) {
        super.willAppear(animated)
        workoutsTableView.deselectSelectedRowAnimated(true)
    }
}
