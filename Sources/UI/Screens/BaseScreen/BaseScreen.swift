//
//  BaseScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/28/14.
//  Copyright (c) 2014 visput. All rights reserved.
//

import UIKit

class BaseScreen: UIViewController {
    
    let modelProvider = ModelProvider.provider
    
    var isViewDisplayed: Bool {
        get {
            return isViewLoaded() && view.window != nil
        }
    }
}
