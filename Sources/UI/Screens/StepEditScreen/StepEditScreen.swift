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
    var stepDidCancelAction: (() -> Void)?
    
    var step: Step!
    
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
            configureNameController()
    
        } else if segue.identifier! == "StepDuration" {
            durationController = segue.destinationViewController as! DurationViewController
            configureDurationController()
        }
    }
}

extension StepEditScreen {
    
    @objc private func cancelButtonDidPress(sender: AnyObject) {
        stepEditView.endEditing(true)
        stepDidCancelAction?()
    }
    
    @objc private func doneButtonDidPress(sender: AnyObject) {
        stepEditView.endEditing(true)
        if validateStep() {
            stepDidEditAction?(step: step)
        }
    }
}

extension StepEditScreen {
    
    override func configureBarButtonItems() {
        super.configureBarButtonItems()
        if backButtonShown() {
            // Show red back button item instead of green button.
            navigationItem.leftBarButtonItem = UIBarButtonItem.greenBackItemWithAlignment(.Left,
                target: self,
                action: Selector("backButtonDidPress:"))
            
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem.greenCancelItemWithAlignment(.Left,
                target: self,
                action: Selector("cancelButtonDidPress:"))
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.greenDoneItemWithAlignment(.Right,
            target: self,
            action: Selector("doneButtonDidPress:"))
    }
    
    private func fillViewWithStep(step: Step) {
        if step.isEmpty() {
            title = NSLocalizedString("New Step", comment: "")
        } else {
            title = NSLocalizedString("Edit Step", comment: "")
        }
        
        nameController.text = step.name
        nameController.textMaxLength = step.nameMaxLength
        
        if step.name.isEmpty {
            nameController.active = true
        }
        
        let duration = step.durationGoal ?? durationController.defaultDuration
        durationController.setDuration(duration, animated: false)
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
    
    private func configureDurationController() {
        durationController.didSelectDurationAction = { [unowned self] duration in
            self.step = self.step.stepBySettingDurationGoal(duration)
        }
    }
    
    private func validateStep() -> Bool {
        if step.name.isEmpty {
            nameController.setInvalidWithErrorTitle(NSLocalizedString("Error", comment: ""),
                errorMessage: NSLocalizedString("Step name is required field.", comment: ""))
        } else {
            nameController.setValid()
        }
        
        return nameController.valid
    }
}
