//
//  WorkoutEditView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 10/25/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class WorkoutEditView: BaseView {
    
    @IBOutlet private(set) weak var nameField: UITextField!
    @IBOutlet private(set) weak var stepsTableView: UITableView!
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        stepsTableView.setEditing(true, animated: false)
    }
}
