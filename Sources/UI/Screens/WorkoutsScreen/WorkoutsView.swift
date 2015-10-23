//
//  WorkoutsView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 3/21/15.
//  Copyright (c) 2015 visput. All rights reserved.
//

import Foundation
import UIKit

class WorkoutsView: BaseView {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var modeButtonItem: UIBarButtonItem!
    
    func applyEditMode() {
        mode = .Edit
        modeButtonItem.title = mode.title()
        tableView.setEditing(true, animated: true)
    }
    
    func applyStandardMode() {
        mode = .Standard
        modeButtonItem.title = mode.title()
        tableView.setEditing(false, animated: true)
    }
}