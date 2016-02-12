//
//  WorkoutsSourceFactory.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/3/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

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
    private(set) var userWorkokutsSource: UserWorkoutsSource!
    private(set) var defaultWorkoutsSource: DefaultWorkoutsSource!
    
    weak var workoutsCollectionView: ActionableCollectionView! {
        didSet {
            userWorkokutsSource.workoutsCollectionView = workoutsCollectionView
            defaultWorkoutsSource.workoutsCollectionView = workoutsCollectionView
        }
    }
    
    init(sourceType: WorkoutsSourceType,
        viewController: UIViewController,
        workoutsProvider: WorkoutsProvider,
        navigationManager: NavigationManager) {
            
            self.userWorkokutsSource = UserWorkoutsSource(viewController: viewController,
                workoutsProvider: workoutsProvider,
                navigationManager: navigationManager)
            
            self.defaultWorkoutsSource = DefaultWorkoutsSource(viewController: viewController,
                workoutsProvider: workoutsProvider,
                navigationManager: navigationManager)
            
            self.currentSourceType = sourceType
            configureCurrentSource()
    }
    
    private func configureCurrentSource() {
        switch currentSourceType {
        case .UserWorkouts:
            currentSource = userWorkokutsSource
            userWorkokutsSource.active = true
            defaultWorkoutsSource.active = false
            
        case .DefaultWorkouts:
            currentSource = defaultWorkoutsSource
            userWorkokutsSource.active = false
            defaultWorkoutsSource.active = true
        }
    }
}
