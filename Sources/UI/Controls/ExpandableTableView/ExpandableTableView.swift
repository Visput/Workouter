//
//  ExpandableTableView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/28/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class ExpandableTableView: UIView {

    var delegate: ExpandableTableViewDelegate?
    
    var dataSource: ExpandableTableViewDataSource! {
        didSet {
            configureTableView()
        }
    }
    
    var rowHeight = UITableViewAutomaticDimension {
        didSet {
            tableView.rowHeight = rowHeight
        }
    }
    
    var estimatedRowHeight: CGFloat = 0.0 {
        didSet {
            tableView.rowHeight = rowHeight
        }
    }
    
    @IBOutlet private var tableView: UITableView!
    private var sectionHeaders = [ExpandableTableViewSectionHeader]()
}

extension ExpandableTableView {
    
    func reloadData() {
        sectionHeaders.removeAll()
        var sectionHeader: ExpandableTableViewSectionHeader! = nil
        if sectionHeaders.count != dataSource.numberOfSectionsInExpandableTableView(self) {
            for var section = 0; section < dataSource.numberOfSectionsInExpandableTableView(self); section++ {
                sectionHeader = dataSource.expandableTableView(self, sectionHeaderAtIndex: section)
                sectionHeader.addTarget(self, action: "sectionHeaderDidPress:", forControlEvents: .TouchUpInside)
                sectionHeaders.append(sectionHeader)
            }
        }
        
        tableView.rowHeight = rowHeight
        tableView.estimatedRowHeight = estimatedRowHeight
        tableView.reloadData()
    }
    
    func openSection(section: Int, animated: Bool) {
        let sectionHeader = sectionHeaders[section]
        sectionHeader.setOpened(true, animated: animated)
        
        var indexPaths = [NSIndexPath]()
        for var row = 0; row < dataSource.expandableTableView(self, numberOfRowsInSection: section); row++ {
            indexPaths.append(NSIndexPath(forRow: row, inSection: section))
        }
        if dataSource.expandableTableView(self, numberOfRowsInSection: section) != 0 {
            let cachedValue = UIView.areAnimationsEnabled()
            UIView.setAnimationsEnabled(animated)
            
            let topIndexPath = NSIndexPath(forRow: 0, inSection: section)
            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
            tableView.scrollToRowAtIndexPath(topIndexPath, atScrollPosition: .Top, animated: animated)
         
            UIView.setAnimationsEnabled(cachedValue)
        }
        
        delegate?.expandableTableView?(self, didOpenSection: section)
    }
    
    func closeSection(section: Int, animated: Bool) {
        let sectionHeader = sectionHeaders[section]
        sectionHeader.setOpened(false, animated: animated)
        
        var indexPaths = [NSIndexPath]()
        for var row = 0; row < dataSource.expandableTableView(self, numberOfRowsInSection: section); row++ {
            indexPaths.append(NSIndexPath(forRow: row, inSection: section))
        }
        
        let cachedValue = UIView.areAnimationsEnabled()
        UIView.setAnimationsEnabled(animated)
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
        UIView.setAnimationsEnabled(cachedValue)
        
        delegate?.expandableTableView?(self, didCloseSection: section)
    }
    
    func dequeueReusableCellWithIdentifier(identifier: String) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(identifier)!
    }
}

extension ExpandableTableView: UITableViewDelegate, UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.numberOfSectionsInExpandableTableView(self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        let sectionHeader = sectionHeaders[section]
        if sectionHeader.opened {
            numberOfRows = dataSource.expandableTableView(self, numberOfRowsInSection: section)
        }
        
        return numberOfRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return dataSource.expandableTableView(self, cellForRowAtIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = sectionHeaders[section]
        return sectionHeader
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionHeader = sectionHeaders[section]
        return sectionHeader.bounds.size.height
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.expandableTableView?(self, didSelectRowAtIndexPath: indexPath)
    }
}

extension ExpandableTableView {
    
    private func configureTableView() {
        if tableView == nil {
            // Configure table view if it isn't initialized by interface builder.
            tableView = UITableView(frame: bounds, style: .Grouped)
            tableView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            tableView.translatesAutoresizingMaskIntoConstraints = true
            addSubview(tableView)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Call 'reloadData' before setting 'tableFooterView' because
        // 'tableFooterView' initialization results in calling 'reloadData' for 'UITableView' object.
        reloadData()
    }
    
    @IBAction private func sectionHeaderDidPress(sectionHeader: ExpandableTableViewSectionHeader) {
        if sectionHeader.opened {
            closeSection(sectionHeaders.indexOf(sectionHeader)!, animated: true)
        } else {
            openSection(sectionHeaders.indexOf(sectionHeader)!, animated: true)
        }
    }
}
