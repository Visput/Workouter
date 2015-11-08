//
//  UITableView+Deselect.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/8/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

extension UITableView {
    
    func deselectSelectedRowAnimated(animated: Bool) {
        guard let indexPath = indexPathForSelectedRow else { return }
        deselectRowAtIndexPath(indexPath, animated: animated)
    }
}