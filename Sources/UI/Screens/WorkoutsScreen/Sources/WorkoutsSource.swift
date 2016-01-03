//
//  WorkoutsSource.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/1/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

protocol WorkoutsSource: UITableViewDataSource, UITableViewDelegate {
    
    var editable: Bool { get set }
    
    func searchWorkoutsWithText(text: String)
    
    func resetSearchResults()
    
    func previewScreenForCellAtIndexPath(indexPath: NSIndexPath) -> UIViewController?
}
