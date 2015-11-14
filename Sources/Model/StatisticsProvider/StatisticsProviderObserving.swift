//
//  StatisticsProviderObserving.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/14/15.
//  Copyright © 2015 visput. All rights reserved.
//

import Foundation

protocol StatisticsProviderObserving {
    
    func statisticsProvider(provider: StatisticsProvider, didUpdateMostFrequentlyPlayedWorkout workout: Workout?)
}
