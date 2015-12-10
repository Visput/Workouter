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
    
    override func didLoad() {
        super.didLoad()
        workoutsTableView.rowHeight = UITableViewAutomaticDimension
        workoutsTableView.estimatedRowHeight = 100.0
    }
    
    override func willAppear(animated: Bool) {
        super.willAppear(animated)
        workoutsTableView.deselectSelectedRowAnimated(true)
    }
}
