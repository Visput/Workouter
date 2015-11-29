//
//  ExpandableTableViewSectionHeader.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/28/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class ExpandableTableViewSectionHeader: UIControl {

    var opened = false
    
    func setOpened(opened: Bool, animated: Bool) {
        self.opened = opened
    }
}
