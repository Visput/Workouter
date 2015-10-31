//
//  SearchController.swift
//  Workouter
//
//  Created by Uladzimir Papko on 10/31/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class SearchController: UISearchController {

    var enabled = true {
        didSet {
            searchBar.userInteractionEnabled = enabled
            searchBar.alpha = enabled ? 1.0 : 0.5
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dimsBackgroundDuringPresentation = false
    }
}
