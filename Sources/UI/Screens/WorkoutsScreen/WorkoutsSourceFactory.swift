//
//  WorkoutsSourceFactory.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/3/16.
//  Copyright © 2016 visput. All rights reserved.
//

import Foundation

enum WorkoutsSourceType: Int {
    case User = 0
    case All = 1
}

class WorkoutsSourceFactory {
    
    var currentSourceType: WorkoutsSourceType {
        didSet {
            configureCurrentSource()
        }
    }
    
    private(set) var currentSource: WorkoutsSource!
    private(set) var userWorkokutsSource: WorkoutsSource!
    private(set) var allWorkoutsSource: WorkoutsSource!
    
    init(sourceType: WorkoutsSourceType,
        workoutsProvider: WorkoutsProvider,
        navigationManager: NavigationManager) {
            
            self.userWorkokutsSource = UserWorkoutsSource(workoutsProvider: workoutsProvider, navigationManager: navigationManager)
            self.allWorkoutsSource = AllWorkoutsSource(workoutsProvider: workoutsProvider, navigationManager: navigationManager)
            self.currentSourceType = sourceType
            configureCurrentSource()
    }
    
    private func configureCurrentSource() {
        switch currentSourceType {
        case .User:
            currentSource = userWorkokutsSource
        case .All:
            currentSource = allWorkoutsSource
        }
    }
}
