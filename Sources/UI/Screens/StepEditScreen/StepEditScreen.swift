//
//  StepEditScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/28/14.
//  Copyright (c) 2014 visput. All rights reserved.
//

import UIKit

class StepEditScreen: BaseScreen {
    
    var stepDidEditAction: ((step: Step) -> ())?
    
    var step: Step! {
        didSet {
            if step == nil {
                step = Step.emptyStep()
            } else if isViewLoaded() {
                fillViewWithStep(step)
            }
        }
    }
    
    private var descriptionController: TextViewController!
    private var durationController: DurationViewController!
    
    private var navigationManager: NavigationManager {
        return modelProvider.navigationManager
    }
    
    private var stepEditView: StepEditView {
        return view as! StepEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillViewWithStep(step)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "StepDescription" {
            descriptionController = segue.destinationViewController as! TextViewController
        } else if segue.identifier! == "StepDuration" {
            durationController = segue.destinationViewController as! DurationViewController
        }
    }
}

extension StepEditScreen {
    
    @IBAction private func doneButtonDidPress(sender: AnyObject) {
        step = step.stepBySettingDuration(durationController.duration)
        stepDidEditAction?(step: step)
    }
}

extension StepEditScreen {
    
    private func fillViewWithStep(step: Step) {
        stepEditView.nameField.text = step.name
        durationController.setDuration(step.duration, animated: false)
        descriptionController.text = step.stepDescription
    }
}
