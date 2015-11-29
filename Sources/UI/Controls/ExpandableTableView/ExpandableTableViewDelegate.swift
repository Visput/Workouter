//
//  ExpandableTableViewDelegate.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/28/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

@objc protocol ExpandableTableViewDelegate {
    
    optional func expandableTableView(tableView: ExpandableTableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    optional func expandableTableView(tableView: ExpandableTableView, didOpenSection section: Int)
    optional func expandableTableView(tableView: ExpandableTableView, didCloseSection section: Int)
}
