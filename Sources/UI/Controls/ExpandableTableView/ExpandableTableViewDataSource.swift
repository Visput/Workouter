//
//  ExpandableTableViewDataSource.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/28/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

@objc protocol ExpandableTableViewDataSource {
    
    func numberOfSectionsInExpandableTableView(tableView: ExpandableTableView) -> Int
    func expandableTableView(tableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int
    func expandableTableView(tableView: ExpandableTableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    func expandableTableView(tableView: ExpandableTableView, sectionHeaderAtIndex index: Int) -> ExpandableTableViewSectionHeader
}
