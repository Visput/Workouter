//
//  WorkoutsSourceFactory.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/3/16.
//  Copyright © 2016 visput. All rights reserved.
//

import Foundation

enum WorkoutsSourceType: Int {
    case UserWorkouts = 0
    case DefaultWorkouts = 1
}

class WorkoutsSourceFactory {
    
    var currentSourceType: WorkoutsSourceType {
        didSet {
            configureCurrentSource()
        }
    }
    
    private(set) var currentSource: WorkoutsSource!
    private(set) var userWorkokutsSource: WorkoutsSource!
    private(set) var defaultWorkoutsSource: WorkoutsSource!
    
    init(sourceType: WorkoutsSourceType,
        workoutsProvider: WorkoutsProvider,
        navigationManager: NavigationManager) {
            
            self.userWorkokutsSource = UserWorkoutsSource(workoutsProvider: workoutsProvider, navigationManager: navigationManager)
            self.defaultWorkoutsSource = DefaultWorkoutsSource(workoutsProvider: workoutsProvider, navigationManager: navigationManager)
            self.currentSourceType = sourceType
            configureCurrentSource()
    }
    
    private func configureCurrentSource() {
        switch currentSourceType {
        case .UserWorkouts:
            currentSource = userWorkokutsSource
        case .DefaultWorkouts:
            currentSource = defaultWorkoutsSource
        }
    }
}
