//
//  BaseView.swift
//  Workouter
//
//  Created by Vladimir Popko on 3/22/15.
//  Copyright (c) 2015 visput. All rights reserved.
//

import Foundation
import UIKit

class BaseView: UIView {
    
    enum ViewMode {
        case Standard
        case Edit
        
        func title() -> NSString {
            switch self {
            case .Standard:
                return NSLocalizedString("Edit", comment: "")
            case .Edit:
                return NSLocalizedString("Done", comment: "")
            }
        }
    }
    
    var mode = ViewMode.Standard
}