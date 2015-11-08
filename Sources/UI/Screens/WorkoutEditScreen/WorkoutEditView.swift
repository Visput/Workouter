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

    override func awakeFromNib() {
        super.awakeFromNib()
        stepsTableView.setEditing(true, animated: false)
    }
    
    override func willAppear(animated: Bool) {
        super.willAppear(animated)
        stepsTableView.deselectSelectedRowAnimated(true)
    }
}