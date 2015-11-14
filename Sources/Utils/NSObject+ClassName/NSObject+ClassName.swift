//
//  ClassNameExtension.swift
//  Workouter
//
//  Created by Uladzimir Papko on 10/26/15.
//  Copyright © 2015 visput. All rights reserved.
//

import Foundation

extension NSObject {
    
    class func className() -> String {
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
}
