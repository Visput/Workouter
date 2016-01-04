//
//  WorkoutsProviderObserving.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/13/15.
//  Copyright © 2015 visput. All rights reserved.
//

import Foundation

protocol WorkoutsProviderObserving: AnyObject {
    
    func workoutsProvider(provider: WorkoutsProvider, didUpdateUserWorkouts userWorkouts: [Workout])
}
