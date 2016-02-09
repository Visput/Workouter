//
//  CircleProgressView.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/9/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

final class CircleProgressView: UIView {
    
    var trackWidth: CGFloat = 4.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var progressWidth: CGFloat = 4.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var roundedCornerWidth: CGFloat = 2.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var fillColor: UIColor = UIColor.clearColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var progressItems = [ProgressViewItem]() {
        didSet {
            maxProgress = progressItems.reduce(0.0, combine: { (sum: CGFloat, item: ProgressViewItem) -> CGFloat in
                sum + item.progress
            })
            
            setNeedsDisplay()
        }
    }
    
    var progress: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private(set) var maxProgress: CGFloat = 0
    
    func setProgress(progress: CGFloat, animated: Bool) {
        if animated {
            UIView.transitionWithView(self,
                duration: 1.0,
                options: .TransitionCrossDissolve,
                animations: { () -> Void in
                    self.progress = progress
                    self.layer.displayIfNeeded()
                }, completion: nil)
        } else {
            self.progress = progress
        }
    }
    
    override func drawRect(rect: CGRect) {
        drawProgressInRect(rect)
    }
}

extension CircleProgressView {
    
    private func drawProgressInRect(rect: CGRect) {
        let circle = circleDimensionsForRect(rect)
        let context = UIGraphicsGetCurrentContext()
        
        // Circle.
        CGContextSetFillColorWithColor(context, fillColor.CGColor)
        CGContextFillEllipseInRect(context, rect)
        CGContextStrokePath(context)
        
        // Track.
        var currentTrackAngle: CGFloat = CGFloat(-M_PI_2)
        for progressItem in progressItems {
            CGContextSetLineWidth(context, trackWidth)
            CGContextSetStrokeColorWithColor(context, progressItem.trackTintColor.CGColor)
            
            let newTrackAngle = currentTrackAngle + (progressItem.progress / maxProgress).progressToRadians
            
            CGContextAddArc(context, circle.center.x, circle.center.y, circle.radius, currentTrackAngle, newTrackAngle, 0)
            CGContextStrokePath(context)
            
            currentTrackAngle = newTrackAngle
        }
        
        // Progress.
        var currentProgressAngle: CGFloat = CGFloat(-M_PI_2)
        var currentProgress: CGFloat = 0.0
        let finalProgressAngle = (progress / maxProgress).progressToRadians - CGFloat(M_PI_2)
        
        for progressItem in progressItems {
            guard currentProgress < progress else { break }
            
            CGContextSetLineWidth(context, progressWidth)
            CGContextSetStrokeColorWithColor(context, progressItem.progressTintColor.CGColor)
            
            var newProgressAngle = currentProgressAngle + (progressItem.progress / maxProgress).progressToRadians
            newProgressAngle = min(newProgressAngle, finalProgressAngle)
            
            CGContextAddArc(context, circle.center.x, circle.center.y, circle.radius, currentProgressAngle, newProgressAngle, 0)
            CGContextStrokePath(context)
            
            currentProgressAngle = newProgressAngle
            currentProgress = min(currentProgress + progressItem.progress, progress)
        }
    }
    
    private func circleDimensionsForRect(rect: CGRect) -> (rect: CGRect, center: CGPoint, radius: CGFloat) {
        let minDimension = min(bounds.size.width, bounds.size.height)
        let circleRadius = (minDimension - max(trackWidth, progressWidth)) / 2.0
        let circleCenter = CGPoint(x: CGRectGetMidX(rect), y: CGRectGetMidY(rect))
        
        let circleRect = CGRect(x: circleCenter.x - circleRadius,
            y: circleCenter.y - circleRadius,
            width: 2.0 * circleRadius,
            height: 2.0 * circleRadius)
        
        return (circleRect, circleCenter, circleRadius)
    }
}

private extension CGFloat {
    
    var progressToRadians: CGFloat {
        return self * 2.0 * CGFloat(M_PI)
    }
}
