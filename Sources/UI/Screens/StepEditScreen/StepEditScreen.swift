//
//  StepEditScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/28/14.
//  Copyright (c) 2014 visput. All rights reserved.
//

import UIKit

final class StepEditScreen: BaseScreen {
    
    var stepDidEditAction: ((step: Step) -> Void)?
    
    var step: Step!
    
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
            configureNameController()
            
        } else if segue.identifier! == "StepDescription" {
            descriptionController = segue.destinationViewController as! TextViewController
            configureDescriptionController()
            
        } else if segue.identifier! == "StepDuration" {
            durationController = segue.destinationViewController as! DurationViewController
            configureDurationController()
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
        switch step.type {
        case .Exercise:
            stepEditView.setNameViewHidden(false)
            nameController.text = step.name
            nameController.textMaxLength = step.nameMaxLength
            if step.name.isEmpty {
                nameController.active = true
            }
            title = NSLocalizedString("Step", comment: "")
            
        case .Rest:
            stepEditView.setNameViewHidden(true)
            title = step.name
        }
        
        descriptionController.text = step.stepDescription
        descriptionController.textMaxLength = step.descriptionMaxLength
        
        let duration = step.duration == 0 ? durationController.defaultDuration : step.duration
        durationController.setDuration(duration, animated: false)
    }
    
    private func configureTextControllers() {
        nameController.nextTextViewController = descriptionController
    }
    
    private func configureNameController() {
        nameController.placeholder = NSLocalizedString("Name", comment: "")
        nameController.descriptionTitle = NSLocalizedString("Step Name", comment: "")
        nameController.descriptionMessage = NSLocalizedString("Step name is short description of your step.", comment: "")
        nameController.didChangeTextAction = { [unowned self] text in
            self.step = self.step.stepBySettingName(text)
            self.nameController.setValid()
        }
    }
    
    private func configureDescriptionController() {
        switch step.type {
        case .Exercise:
            descriptionController.placeholder = NSLocalizedString("Description (Optional)", comment: "")
            descriptionController.descriptionTitle = NSLocalizedString("Step Description", comment: "")
            descriptionController.descriptionMessage = NSLocalizedString("Step description is detailed information about your step.",
                comment: "")
            
        case .Rest:
            descriptionController.placeholder = NSLocalizedString("Rest description (Optional)", comment: "")
            descriptionController.descriptionTitle = NSLocalizedString("Rest Description", comment: "")
            descriptionController.descriptionMessage = NSLocalizedString("Rest description is detailed information about your rest.",
                comment: "")
            
        }
        
        descriptionController.didChangeTextAction = { [unowned self] text in
            self.step = self.step.stepBySettingDescription(text)
        }
    }
    
    private func configureDurationController() {
        durationController.didSelectDurationAction = { [unowned self] duration in
            self.step = self.step.stepBySettingDuration(duration)
        }
    }
    
    private func validateStep() -> Bool {
        if step.name.isEmpty {
            nameController.setInvalidWithErrorTitle("Error", errorMessage: "Step name is required field.")
        } else {
            nameController.setValid()
        }
        
        return nameController.valid
    }
}
