//
//  P2MSCountdownTimer.swift
//  P2MSCountDownTimer
//
//  Created by Pyae Phyo Myint Soe on 26/6/15.
//  Copyright (c) 2015 PYAE PHYO MYINT SOE. All rights reserved.
//

import UIKit

let FIRE_INTERVAL:NSTimeInterval = 0.5

protocol P2MSCountdownTimerCallback: class{
    func timerExpired(timer: P2MSCountdownTimer)
    func timerStarted(timer: P2MSCountdownTimer)
    func timerTickedInSeconds(curSecond : Int, timer aTimer: P2MSCountdownTimer)
}

enum COUNT_DOWN_TYPE {
    case COUNT_DOWN_TYPE_SECONDS, COUNT_DOWN_TYPE_MINUTES, COUNT_DOWN_TYPE_HOURS
}

class P2MSCountdownTimer: UIView {
    
    weak var delegate: P2MSCountdownTimerCallback?
    weak var associatedColorChangeLabel : UILabel?
    
    var radius, lineWidth: CGFloat;
    var isTimerActvie : Bool = false
    private var outerRadius :CGFloat{ get{ return radius; } };
    private var innerRadius :CGFloat{ get{ return radius-lineWidth; } };
    var startTime: NSDate? = nil, endTime : NSDate? = nil
    var strokeBackgroundColor: UIColor
    var timerExpiredColor: UIColor? = nil
    var completedPercentage: CGFloat = 0
    var elapsedTimeColors : Array = [ UIColor(red: 0.03921, green: 0.513725, blue: 0.23529, alpha: 1.0), UIColor(red: 0.03921, green: 0.513725, blue: 0.23529, alpha: 1.0), UIColor(red: 0.8, green: 0.6, blue: 0.0, alpha: 1.0), UIColor(red: 0.8, green: 0.0, blue: 0.0, alpha: 1.0)];
    
    private var timer : NSTimer? = nil
    private var startIntervals: NSTimeInterval = 0, endIntervals: NSTimeInterval = 0;
    private var innerPadding: CGFloat = 1;
    private var curCountdownTick : NSTimeInterval = -1
    
    var countDownType : COUNT_DOWN_TYPE = COUNT_DOWN_TYPE.COUNT_DOWN_TYPE_SECONDS
    var countdownLabel : UILabel?
    var showCountDownLabel : Bool{
        get{
            return countdownLabel != nil
        }
        set(showLabel){
            if showLabel{
                if countdownLabel == nil{
                    countdownLabel = UILabel.autoLayoutView()
                    countdownLabel!.textAlignment = NSTextAlignment.Center
                    self.addSubview(countdownLabel!)
                    self.matchSidesForView(self, withView: countdownLabel!)
                }
            }else{
                countdownLabel?.removeFromSuperview()
                countdownLabel = nil
            }
        }
    }


    override init(frame: CGRect) {
        self.radius = 10;
        self.lineWidth = 2;
        self.strokeBackgroundColor = UIColor(white: 0.8, alpha: 1.0)
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    func DEGREES_TO_RADIANS(degree : CGFloat) -> CGFloat{
        return (CGFloat(M_PI) * degree)/180.0;
    }
    
    convenience init(){
        self.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        radius = 10;
        lineWidth = 2;
        self.strokeBackgroundColor = UIColor(white: 0.8, alpha: 1.0)
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect);
        let center :CGPoint = CGPoint(x: bounds.size.width/2, y: bounds.size.height/2)
        let lineWidth : CGFloat = self.outerRadius - self.innerRadius;
        let calcRadius : CGFloat = self.innerRadius + lineWidth/2;
        
        let backgroundCircle: UIBezierPath = UIBezierPath(arcCenter: center, radius: calcRadius, startAngle: DEGREES_TO_RADIANS(0.0), endAngle: DEGREES_TO_RADIANS(360.0), clockwise: true);
        backgroundCircle.lineWidth = lineWidth;
        strokeBackgroundColor.setStroke()
        backgroundCircle.stroke()
        
        var startAngle : CGFloat = 0.0;
        var degrees = CGFloat(360.0);
        let mtimerExpired = isTimerExpired();
        if (!isTimerStarted()) {
            degrees = 0.0;
            self.completedPercentage = 0.0;
            updateTimerLabelWithInterval(0)
        }else if (!mtimerExpired){
            startAngle = 270.0;
            let curIntervals = NSDate().timeIntervalSince1970;
            self.completedPercentage = CGFloat(min((curIntervals-self.startIntervals)/(self.endIntervals-self.startIntervals),1.0));
            let newInterval = endIntervals - curIntervals
            if newInterval != curCountdownTick{
                curCountdownTick = newInterval
                let calInterval = Int(ceil(endIntervals-curIntervals))
                updateTimerLabelWithInterval(calInterval)
                delegate?.timerTickedInSeconds(calInterval, timer: self)
            }
            degrees = self.completedPercentage * CGFloat(360);
            degrees = (degrees < CGFloat(90)) ? CGFloat(270)+degrees : degrees-CGFloat(90);
        }else{
            self.completedPercentage = CGFloat(1.0);
            updateTimerLabelWithInterval(0)
        }
        
        let elapsedTimePath = UIBezierPath(arcCenter: center, radius: calcRadius, startAngle: DEGREES_TO_RADIANS(startAngle), endAngle: DEGREES_TO_RADIANS(degrees), clockwise: true)
        var fillColor : UIColor?
        if isTimerExpired(){
            if isTimerActvie{
                isTimerActvie = false
                delegate?.timerExpired(self)
            }
            if timerExpiredColor != nil{
                fillColor = timerExpiredColor
            }else{
                fillColor = elapsedTimeColors.last
            }
        }else{
            let maxColorsIndex = elapsedTimeColors.count-1
            let individualColorSegment : CGFloat = CGFloat(1.0)/CGFloat(maxColorsIndex)
            let currentBetColorIndex = self.completedPercentage/individualColorSegment

            let baseColorIndex : Int = min(Int(floor(currentBetColorIndex)), maxColorsIndex-1)
            let nextColorIndex : Int = min(baseColorIndex+1, maxColorsIndex)
            
            let localisedMax : CGFloat = CGFloat(nextColorIndex) * individualColorSegment
            let localisedMin : CGFloat = CGFloat(baseColorIndex) * individualColorSegment
            let localisedPercentage :CGFloat = (self.completedPercentage-localisedMin)/(localisedMax-localisedMin)
            fillColor = UIColor.interpolatedColorBetweenColor(elapsedTimeColors[baseColorIndex], andColor: elapsedTimeColors[nextColorIndex], ratio: localisedPercentage)
        }
        fillColor!.setStroke()
        elapsedTimePath.lineWidth = lineWidth
        elapsedTimePath.stroke()

        let ctx = UIGraphicsGetCurrentContext()
        var backColor : UIColor
        if startAngle == degrees{
            backColor = strokeBackgroundColor
        }else{
            backColor = fillColor!
            associatedColorChangeLabel?.textColor = fillColor
        }
        let colors = CGColorGetComponents(backColor.CGColor)
        let backColorNoOfComponents = CGColorGetNumberOfComponents(backColor.CGColor)
        let modifiedAlphaComponent : CGFloat = 0.5
        if backColorNoOfComponents == 2{
            CGContextSetRGBFillColor(ctx, colors[0], colors[0], colors[0], modifiedAlphaComponent)
        }else if backColorNoOfComponents == 4{
            CGContextSetRGBFillColor(ctx, colors[0], colors[1], colors[2], modifiedAlphaComponent)
        }else{
            CGContextSetRGBFillColor(ctx, colors[0], colors[1], colors[2], modifiedAlphaComponent)
        }
        CGContextFillEllipseInRect(ctx, CGRect(x: center.x-self.innerRadius+self.innerPadding, y: center.y-self.innerRadius+self.innerPadding, width: (self.innerRadius-self.innerPadding)*2, height: (self.innerRadius-self.innerPadding)*2))
        CGContextFillPath(ctx)
        
    }
    
    deinit{
        clearTimer()
    }
    
    func clearTimer(){
        if((timer?.valid) != nil){
            timer?.invalidate()
            delegate?.timerExpired(self)
        }
        timer = nil;
    }
    
    func startTimer(){
        clearTimer()
        endIntervals = endTime!.timeIntervalSince1970
        startIntervals = startTime!.timeIntervalSince1970
        isTimerActvie = true
        if(startTime?.compare(NSDate()) ==  NSComparisonResult.OrderedDescending){
            timer = NSTimer.init(fireDate: startTime!, interval:FIRE_INTERVAL, target: self, selector: Selector ("updateTimerLayout"), userInfo: nil, repeats: true);
        }else{
            timer = NSTimer.scheduledTimerWithTimeInterval(FIRE_INTERVAL, target: self, selector: Selector("updateTimerLayout"), userInfo: nil, repeats: true);
        }
        delegate?.timerStarted(self)
    }
    
    func updateTimerLabelWithInterval(curInterval : Int){
        if countdownLabel != nil && startIntervals != endIntervals{
            countdownLabel?.text = String(curInterval)//
        }
    }
    
    func isTimerStarted() -> Bool{
        if startTime != nil{
            return (NSDate().compare(startTime!) != NSComparisonResult.OrderedAscending);
        }
        return false
    }
    
    func isTimerExpired() -> Bool{
        if endTime != nil{
            return (NSDate().compare(endTime!) != NSComparisonResult.OrderedAscending);
        }
        return true
    }
    
    func updateTimerLayout(){
        let isExpired : Bool = isTimerExpired()
        if(!isExpired){
            setNeedsDisplay();
        }else{
            timer?.invalidate();
            timer = nil;
            setNeedsDisplay()
        }
    }
}
