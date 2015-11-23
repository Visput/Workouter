//
//  StepEditScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/28/14.
//  Copyright (c) 2014 visput. All rights reserved.
//

import UIKit

class StepEditScreen: BaseScreen {
    
    var stepDidEditAction: ((step: Step) -> Void)?
    
    var step: Step = Step.emptyExersize()
    
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
        configureTextControllers()
        fillViewWithStep(step)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "StepName" {
            nameController = segue.destinationViewController as! TextViewController
            nameController.placeholder = NSLocalizedString("Name", comment: "")
            nameController.descriptionTitle = NSLocalizedString("Step Name", comment: "")
            nameController.descriptionMessage = NSLocalizedString("Step name is short description of your step.", comment: "")
            nameController.didChangeTextAction = { [unowned self] text in
                self.step = self.step.stepBySettingName(text)
                self.nameController.setValid()
            }
            
        } else if segue.identifier! == "StepDescription" {
            descriptionController = segue.destinationViewController as! TextViewController
            descriptionController.placeholder = NSLocalizedString("Description (Optional)", comment: "")
            descriptionController.descriptionTitle = NSLocalizedString("Step Description", comment: "")
            descriptionController.descriptionMessage = NSLocalizedString("Step description is detailed information about your step.",
                comment: "")
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
        stepEditView.endEditing(true)
        if validateStep() {
            stepDidEditAction?(step: step)
        }
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
    
    private func configureTextControllers() {
        nameController.nextTextViewController = descriptionController
    }
    
    private func validateStep() -> Bool {
        let valid = !nameController.text.isEmpty
        if valid {
            nameController.setValid()
        } else {
            nameController.setInvalidWithErrorTitle("Error", errorMessage: "Step name is required field.")
        }
        return valid
    }
}
