//
//  StatisticsScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/14/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit
import Charts

final class StatisticsScreen: BaseScreen {
    
    private var placeholderController: PlaceholderController!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "Placeholder" {
            placeholderController = segue.destinationViewController as! PlaceholderController
        }
    }
}
