//
//  DurationViewController.swift
//  Workouter
//
//  Created by Uladzimir Papko on 10/29/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

class DurationViewController: UIViewController {
    
    /// Default value in seconds (2 mins).
    private(set) var duration = 120
    
    private let durationComponents = [DurationComponent.hour(), DurationComponent.minute(), DurationComponent.second()]
    
    @IBOutlet private var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponentsWithDuration(duration, animated: false)
    }
    
    func setDuration(newDuration: Int, animated: Bool) {
        duration = newDuration
        if isViewLoaded() {
            setComponentsWithDuration(duration, animated:animated)
        }
    }
    
    private func setDurationWithComponents(durationComponents: [DurationComponent], animated: Bool) {
        var newDuration = 0
        for durationComponent in durationComponents {
            newDuration += durationComponent.valueInSeconds
        }
        setDuration(newDuration, animated: animated)
    }
    
    private func setComponentsWithDuration(duration: Int, animated: Bool) {
        for durationComponent in durationComponents {
            durationComponent.setValueWithSeconds(duration)
        }
        
        for (index, durationComponent) in durationComponents.enumerate() {
            pickerView.selectRow(durationComponent.row, inComponent: index, animated: animated)
        }
    }
}

extension DurationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return durationComponents.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let item = durationComponents[component]
        item.row = row
    
        setDurationWithComponents(durationComponents, animated: false)
        
        if duration == 0 {
            let secondsComponent = durationComponents.last!
            secondsComponent.setValue(1)
            setDurationWithComponents(durationComponents, animated: true)
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let item = durationComponents[component]
        return item.numberOfRows
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100.0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let item = durationComponents[component]
        return item.stringValueForRow(row)
    }
}
