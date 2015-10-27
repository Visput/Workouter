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
    
    var step = Step.emptyStep() {
        didSet {
            if isViewLoaded() {
                fillViewWithStep(step)
            }
        }
    }
    
    private var descriptionController: TextViewController!
    
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
        }
    }
    
    @IBAction private func doneButtonDidPress(sender: AnyObject) {
        stepDidEditAction?(step: step)
        navigationController?.popViewControllerAnimated(true)
    }
    
    private func fillViewWithStep(step: Step) {
        stepEditView.nameField.text = step.name
        stepEditView.durationPicker.countDownDuration = step.duration
        descriptionController.textView.text = step.stepDescription
    }
}
