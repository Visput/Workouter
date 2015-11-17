//
//  WorkoutTemplatesView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/3/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class WorkoutTemplatesView: BaseView {

    @IBOutlet private(set) weak var templatesTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        templatesTableView.rowHeight = UITableViewAutomaticDimension
        templatesTableView.estimatedRowHeight = 85.0
    }
    
    override func willAppear(animated: Bool) {
        super.willAppear(animated)
        templatesTableView.deselectSelectedRowAnimated(true)
    }
}
