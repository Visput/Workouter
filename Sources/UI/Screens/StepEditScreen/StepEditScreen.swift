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
    
    var step: Step = Step.emptyStep()
    
    private var descriptionController: TextViewController!
    private var nameController: TextViewController!
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
        if segue.identifier! == "StepName" {
            nameController = segue.destinationViewController as! TextViewController
            nameController.placeholder = NSLocalizedString("Name", comment: "")
            nameController.didChangeTextAction = { [unowned self] text in
                self.step = self.step.stepBySettingName(text)
            }
            
        } else if segue.identifier! == "StepDescription" {
            descriptionController = segue.destinationViewController as! TextViewController
            descriptionController.placeholder = NSLocalizedString("Description (Optional)", comment: "")
            descriptionController.didChangeTextAction = { [unowned self] text in
                self.step = self.step.stepBySettingDescription(text)
            }
            
        } else if segue.identifier! == "StepDuration" {
            durationController = segue.destinationViewController as! DurationViewController
            durationController.didSelectDurationAction = { [unowned self] duration in
                self.step = self.step.stepBySettingDuration(duration)
            }
        }
    }
}

extension StepEditScreen {
    
    @IBAction private func doneButtonDidPress(sender: AnyObject) {
        stepDidEditAction?(step: step)
    }
}

extension StepEditScreen {
    
    private func fillViewWithStep(step: Step) {
        nameController.text = step.name
        nameController.textMaxLength = step.nameMaxLength
        descriptionController.text = step.stepDescription
        descriptionController.textMaxLength = step.descriptionMaxLength
        let duration = step.isEmpty() ? durationController.defaultDuration : step.duration
        durationController.setDuration(duration, animated: false)
        
        if step.isEmpty() {
            nameController.active = true
        }
    }
}
