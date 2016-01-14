//
//  WorkoutPlayerView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/25/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit
import SceneKit

final class WorkoutPlayerView: BaseScreenView {
    
    @IBOutlet private(set) weak var progressView: CircleProgressView!
    @IBOutlet private(set) weak var exerciseSceneView: SCNView!
    
}
