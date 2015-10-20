//
//  AnalyticsTracker.swift
//  Workouter
//
//  Created by Vladimir Popko on 3/30/15.
//  Copyright (c) 2015 visput. All rights reserved.
//

import Foundation
import Flurry_iOS_SDK

class AnalyticsTracker {
    class func startSession() {
        let flurryKey = NSBundle.mainBundle().objectForInfoDictionaryKey("FlurryKey") as! String
        Flurry.startSession(flurryKey)
    }
}
