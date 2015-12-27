//
//  UIPageViewController+PageControl.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/27/15.
//  Copyright © 2015 visput. All rights reserved.
//

import UIKit

extension UIPageViewController {
    
    var pageControl: UIPageControl? {
        get {
            return view.findPageControl()
        }
    }
}

private extension UIView {
    
    func findPageControl() -> UIPageControl? {
        var pageControl: UIPageControl? = nil
        if self is UIPageControl {
            pageControl = self as? UIPageControl
        } else {
            for subview in subviews {
                pageControl = subview.findPageControl()
                
                if pageControl != nil {
                    break
                }
            }
        }
        
        return pageControl
    }
}
