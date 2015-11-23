//
//  DurationComponent.swift
//  Workouter
//
//  Created by Uladzimir Papko on 10/30/15.
//  Copyright © 2015 visput. All rights reserved.
//

import Foundation

final class DurationComponent {
    
    let numberOfRows: Int
    let maxValue: Int
    let valueToSecondsRatio: Int
    
    private(set) var value: Int
    
    var valueInSeconds: Int {
        get {
            return value * valueToSecondsRatio
        }
    }
    
    var row: Int {
        get {
            return ((numberOfRows / (2 * maxValue)) * maxValue) + value
        }
        
        set (newRow) {
            if newRow >= 0 {
                value = newRow % maxValue
            }
        }
    }
    
    init?(maxValue: Int, numberOfRepeats: Int, valueToSecondsRatio: Int, value: Int) {
        self.maxValue = maxValue
        self.numberOfRows = numberOfRepeats * maxValue
        self.valueToSecondsRatio = valueToSecondsRatio
        self.value = value
        
        if  maxValue < 0 ||
            numberOfRepeats <= 0 ||
            valueToSecondsRatio <= 0 ||
            value < 0 ||
            value > maxValue {
                return nil
        }
    }
    
    func setValue(newValue: Int) -> Bool {
        var result = false
        
        if newValue <= maxValue {
            value = newValue
            result = true
        }
        
        return result
    }
    
    func setValueWithSeconds(valueInSeconds: Int) -> Bool {
        var result = false
        
        if valueInSeconds >= 0 {
            value = (valueInSeconds / valueToSecondsRatio) % maxValue
            result = true
        }
        
        return result
    }
    
    func stringValueForRow(row: Int) -> String? {
        var stringValue: String? = nil
        if row >= 0 && row < numberOfRows {
            stringValue = "\(row % maxValue)"
        }
        
        return stringValue
    }
}

extension DurationComponent {
    
    static func hour() -> DurationComponent {
        return DurationComponent(maxValue: 24, numberOfRepeats: 50, valueToSecondsRatio: 3600, value: 0)!
    }
    
    static func minute() -> DurationComponent {
        return DurationComponent(maxValue: 60, numberOfRepeats: 50, valueToSecondsRatio: 60, value: 0)!
    }
    
    static func second() -> DurationComponent {
        return DurationComponent(maxValue: 60, numberOfRepeats: 50, valueToSecondsRatio: 1, value: 0)!
    }
}
