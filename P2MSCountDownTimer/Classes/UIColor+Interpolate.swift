//
//  UIColor+Interpolate.swift
//  P2MSCountDownTimer
//
//  Created by Pyae Phyo Myint Soe on 16/9/15.
//  Copyright © 2015 PYAE PHYO MYINT SOE. All rights reserved.
//

import UIKit

extension UIColor {
    class func interpolatedColorBetweenColor(firstColor: UIColor, andColor lastColor: UIColor, ratio aRatio: CGFloat) -> UIColor{
        let firstColorComponents = CGColorGetComponents(firstColor.CGColor)
        let secondColorComponents = CGColorGetComponents(lastColor.CGColor)
        
        let numberOfComp : Int = CGColorGetNumberOfComponents(firstColor.CGColor)
        var interpolatedComponents = [CGFloat](count: numberOfComp, repeatedValue: 0)
        for index in 0...numberOfComp-1{
            interpolatedComponents[index] = firstColorComponents[index] * (1 - aRatio) + secondColorComponents[index] * aRatio
        }
        let interpolatedCGColor = CGColorCreate(CGColorGetColorSpace(firstColor.CGColor), interpolatedComponents)
        if interpolatedCGColor != nil{
            //no need to call CGColorRelease in swift
            return UIColor(CGColor: interpolatedCGColor!)
        }
        return UIColor.clearColor()
    }
}