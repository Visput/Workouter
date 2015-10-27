//
//  ServicesProvider.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/20/15.
//  Copyright (c) 2015 visput. All rights reserved.
//

import Foundation

class ModelProvider: NSObject {
    
    static let provider = ModelProvider()
    
    private(set) lazy var workoutsProvider: WorkoutsProvider = WorkoutsProvider()
}
