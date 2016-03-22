//
//  MuscleGroupsScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 1/30/16.
//  Copyright © 2016 visput. All rights reserved.
//

import UIKit

final class MuscleGroupsScreen: BaseScreen {

    /// Nil means that user selects all muscle groups (Full Body).
    var muscleGroupDidSelectAction: ((muscleGroup: MuscleGroup?) -> Void)?
    var muscleGroupDidCancelAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MuscleGroupsScreen {
    
    @objc private func searchStepsButtonDidPress(sender: AnyObject) {
        // Search steps in all groups.
        muscleGroupDidSelectAction?(muscleGroup: nil)
    }
    
    @objc private func cancelButtonDidPress(sender: AnyObject) {
        muscleGroupDidCancelAction?()
    }
}

extension MuscleGroupsScreen {
    
    override func configureBarButtonItems() {
        super.configureBarButtonItems()
        navigationItem.leftBarButtonItem = UIBarButtonItem.greenCancelItemWithAlignment(.Left,
            target: self,
            action: #selector(MuscleGroupsScreen.cancelButtonDidPress(_:)))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.greenSearchItemWithAlignment(.Right,
            target: self,
            action: #selector(MuscleGroupsScreen.searchStepsButtonDidPress(_:)))
    }
    
}
