//
//  DurationViewController.swift
//  Workouter
//
//  Created by Uladzimir Papko on 10/29/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class DurationViewController: UIViewController {
    
    var didSelectDurationAction: ((duration: Int) -> Void)?
    
    private(set) var duration: Int {
        didSet {
            didSelectDurationAction?(duration: duration)
        }
    }
    
    let defaultDuration = 120
    let minDuration = 1
    
    private let durationComponents = [DurationComponent.hour(), DurationComponent.minute(), DurationComponent.second()]
    
    @IBOutlet private var pickerView: UIPickerView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        duration = defaultDuration
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        duration = defaultDuration
        super.init(coder: aDecoder)
    }
    
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
        duration = newDuration
    }
    
    private func setComponentAtIndex(index: Int, withRow row: Int, animated: Bool) {
        let durationComponent = durationComponents[index]
        durationComponent.row = row
        pickerView.selectRow(durationComponent.row, inComponent: index, animated: animated)
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
        setComponentAtIndex(component, withRow: row, animated: false)
        setDurationWithComponents(durationComponents, animated: false)
        
        if duration == 0 {
            setDuration(minDuration, animated: true)
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
