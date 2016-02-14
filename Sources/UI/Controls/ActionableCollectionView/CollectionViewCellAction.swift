//
//  CollectionViewCellAction.swift
//  Workouter
//
//  Created by Uladzimir Papko on 2/12/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

final class CollectionViewCellAction: NSObject {
    
    enum Type {
        case Custom
        case Delete
        case Clone
        case Move
    }
    
    let type: Type
    let control: UIControl
    
    init (type: Type, control: UIControl) {
        self.type = type
        self.control = control
        super.init()
    }
}
