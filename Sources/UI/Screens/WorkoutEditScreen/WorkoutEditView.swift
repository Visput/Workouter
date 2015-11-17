//
//  WorkoutEditView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 10/25/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class WorkoutEditView: BaseView {
    
    @IBOutlet private(set) weak var stepsTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stepsTableView.setEditing(true, animated: false)
        stepsTableView.rowHeight = UITableViewAutomaticDimension
        stepsTableView.estimatedRowHeight = 70.0
    }
    
    override func willAppear(animated: Bool) {
        super.willAppear(animated)
        stepsTableView.deselectSelectedRowAnimated(true)
    }
}
