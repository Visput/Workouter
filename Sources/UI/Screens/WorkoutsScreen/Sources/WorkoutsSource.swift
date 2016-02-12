//
//  WorkoutsSource.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/1/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

protocol WorkoutsSource: UICollectionViewDataSource, ActionableCollectionViewDelegate, UIViewControllerPreviewingDelegate {
    
    var active: Bool { get set }
    var currentWorkouts: [Workout] { get }
    
    func searchWorkoutsWithText(text: String)
    func resetSearchResults()
}
