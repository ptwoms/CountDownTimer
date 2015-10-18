//
//  ViewController.swift
//  P2MSCountDownTimer
//
//  Created by Pyae Phyo Myint Soe on 26/6/15.
//  Copyright (c) 2015 PYAE PHYO MYINT SOE. All rights reserved.
//

import UIKit

class ViewController: UIViewController, P2MSCountdownTimerCallback {
    var associatedLabel : UILabel?
    var myTimer : P2MSCountdownTimer?
    @IBOutlet var startButton : UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        myTimer = P2MSCountdownTimer.autoLayoutView()
        self.view.addSubview(myTimer!);
        self.view .addWidth(50, andHeight: 50, toView: myTimer!)
        self.view .addTopPadding(100, withSubView: myTimer!)
        self.view.centerHorizontalSubView(myTimer!)
        myTimer?.radius = 25;
        myTimer?.delegate = self
        myTimer?.lineWidth = 5;
        myTimer?.showCountDownLabel = true
        myTimer?.timerExpiredColor = UIColor.lightGrayColor()
        
        associatedLabel = UILabel.autoLayoutView()
        self.view.addSubview(associatedLabel!)
        self.view.addPadding(10, betweenTopView: myTimer!, andBottomView: associatedLabel!)
        self.view.centerHorizontalSubView(associatedLabel!)
        associatedLabel!.text = ""
        myTimer?.associatedColorChangeLabel = associatedLabel
    }
    
    @IBAction func restartClicked(sender : UIControl){
        myTimer?.startTime = NSDate()
        myTimer?.endTime = NSDate(timeInterval: 5, sinceDate: myTimer!.startTime!)
        myTimer?.startTimer()
        startButton?.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func timerStarted(timer: P2MSCountdownTimer) {
        NSLog("Timer Started")
    }

    func timerExpired(timer: P2MSCountdownTimer) {
        NSLog("Timer Expired")
        associatedLabel!.text = "Timer has expired..."
        startButton?.enabled = true
    }
    
    func timerTickedInSeconds(curSecond: Int, timer aTimer: P2MSCountdownTimer) {
        if aTimer.isTimerStarted() && aTimer.isTimerExpired(){
            associatedLabel!.text = "This quote has expired..."
        }else{
            associatedLabel!.text = String(format: "Next %d seconds remaining...", curSecond)
        }
    }

}

