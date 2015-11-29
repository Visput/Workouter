//
//  String+Duration.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/16/15.
//  Copyright © 2015 visput. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {
    
    class func durationStringForStep(step: Step,
        valueFont: UIFont,
        unitFont: UIFont,
        color: UIColor) -> Self {
            
        return durationStringForDuration(step.duration,
            showSeconds: true,
            valueFont: valueFont,
            unitFont: unitFont,
            color: color)
    }
    
    class func durationStringForWorkout(workout: Workout,
        valueFont: UIFont,
        unitFont: UIFont,
        color: UIColor) -> Self {
            
        let totalDuration = workout.steps.reduce(0) { (sum: Int, step: Step) in
            sum + step.duration
        }
        
        return durationStringForDuration(totalDuration,
            showSeconds: false,
            valueFont: valueFont,
            unitFont: unitFont,
            color: color)
    }

    class func durationStringForDuration(duration: Int,
        showSeconds: Bool,
        valueFont: UIFont,
        unitFont: UIFont,
        color: UIColor) -> Self {
            
        let hourShortUnit = NSLocalizedString(" h", comment: "")
        let hourSingularUnit = NSLocalizedString(" hour", comment: "")
        let hourPluralUnit = NSLocalizedString("hours", comment: "")
        let minuteUnit = NSLocalizedString(" min", comment: "")
        let secondUnit = NSLocalizedString(" sec", comment: "")
        
        let durationString = NSMutableAttributedString()
        
        let components = componentsFromDuration(duration, roundSeconds: !showSeconds)
        
        func appendComponent(value: Int, unit: String) {
            if durationString.length > 0 {
                durationString.appendAttributedString(NSAttributedString(string: " ",
                    attributes: [NSFontAttributeName: valueFont, NSForegroundColorAttributeName: color]))
            }
            
            durationString.appendAttributedString(NSAttributedString(string: String(value),
                attributes: [NSFontAttributeName: valueFont, NSForegroundColorAttributeName: color]))
            
            durationString.appendAttributedString(NSAttributedString(string: unit,
                attributes: [NSFontAttributeName: unitFont, NSForegroundColorAttributeName: color]))
        }
        
        if components.hours > 0 {
            if components.minutes == 0 && components.seconds == 0 {
                if components.hours == 1 {
                    appendComponent(components.hours, unit: hourSingularUnit)
                } else {
                    appendComponent(components.hours, unit: hourPluralUnit)
                }
            } else {
                appendComponent(components.hours, unit: hourShortUnit)
            }
        }
        
        if components.minutes > 0 {
            appendComponent(components.minutes, unit: minuteUnit)
        }
        
        if components.seconds > 0 {
            appendComponent(components.seconds, unit: secondUnit)
        }
        
        return self.init(attributedString: durationString)
    }
    
    private class func componentsFromDuration(var duration: Int, roundSeconds: Bool) -> (hours: Int, minutes: Int, seconds: Int) {
        let secondsInMinute = 60
        let secondsInHour = 3600
        let minutesInHour = 60
        
        var seconds = duration % secondsInMinute
        if roundSeconds && seconds > 0 {
            seconds = 0
            duration += secondsInMinute
        }
        
        let minutes = (duration / secondsInMinute) % minutesInHour
        let hours = duration / secondsInHour
        
        return (hours, minutes, seconds)
    }
}
