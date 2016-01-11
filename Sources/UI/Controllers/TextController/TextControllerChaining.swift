//
//  TextControllerChaining.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/27/15.
//  Copyright © 2015 visput. All rights reserved.
//

import Foundation

protocol TextControllerChaining {
    
    /// Use this property if you need to activate another text controller
    /// when user clicks `return` key.
    /// If this property is nil then current text controller will be
    /// deactivated when user clicks `return` key.
    var nextTextController: TextControllerChaining? { get set }
    
    /// Use this property to activate next text controller in chain
    /// when user clicks `return` key.
    var active: Bool { get set }
}
