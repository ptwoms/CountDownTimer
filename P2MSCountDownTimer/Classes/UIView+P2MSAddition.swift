//
//  UIView+P2MSAddition.swift
//  P2MSCircularBreadCrumbView
//
//  Created by Pyae Phyo Myint Soe on 1/9/15.
//  Copyright (c) 2015 PYAE PHYO MYINT SOE. All rights reserved.
//

import UIKit

extension UIView{
    class func autoLayoutView() -> Self{
        let newView = self.init()
        newView.translatesAutoresizingMaskIntoConstraints = false
        return newView
    }
    
    func removeAllSubViews(){
        for subView in self.subviews{
            subView.removeFromSuperview()
        }
    }
    
    func createBotoomPadding(value: CGFloat, withSubView subView: UIView, andRelation relation: NSLayoutRelation) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: relation, toItem: subView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: value)
    }
    
    func addBottomPadding(value: CGFloat, withSubView subView: UIView, andPriority priority: UILayoutPriority = 1000) -> NSLayoutConstraint {
        let constraint = self .createBotoomPadding(value, withSubView: subView, andRelation: NSLayoutRelation.Equal);
        constraint.priority = priority
        self.addConstraint(constraint)
        return constraint
    }

    func getRelationString(relation : NSLayoutRelation) -> NSString{
        switch(relation){
        case NSLayoutRelation.GreaterThanOrEqual: return ">=";
        case NSLayoutRelation.LessThanOrEqual: return "<=";
        default: return ""
        }
    }

    func createLeftPadding(leftPadding: CGFloat, withSubView subView: UIView, relationship relation: NSLayoutRelation) -> NSLayoutConstraint{
        let view = Dictionary<String,UIView>.DictionaryOfVariableBindings(subView)
        let allConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-(leftspace)-[v1]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: ["leftspace": String(format: "%@%f", self.getRelationString(relation), leftPadding)], views: view)
        return allConstraints[0] 
    }

    func addLeftPadding(leftPadding: CGFloat, withSubView subView: UIView, andPriority priority: UILayoutPriority = 1000) -> NSLayoutConstraint{
        let leftConstraint = self.createLeftPadding(leftPadding, withSubView: subView, relationship: NSLayoutRelation.Equal)
        leftConstraint.priority = priority
        self.addConstraint(leftConstraint)
        return leftConstraint
    }
    
    func createTopPadding(topPadding: CGFloat, withSubView subView: UIView, relationship relation: NSLayoutRelation) -> NSLayoutConstraint{
        let view = Dictionary<String,UIView>.DictionaryOfVariableBindings(subView)
        let allConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(topspace)-[v1]", options: NSLayoutFormatOptions.AlignAllTop, metrics: ["topspace": String(format: "%@%f", self.getRelationString(relation), topPadding)], views: view)
        return allConstraints[0] 
    }
    
    func addTopPadding(topPadding: CGFloat, withSubView subView: UIView, andPriority priority: UILayoutPriority = 1000) -> NSLayoutConstraint{
        let topConstraint = createTopPadding(topPadding, withSubView: subView, relationship: NSLayoutRelation.Equal)
        topConstraint.priority = priority
        self.addConstraint(topConstraint)
        return topConstraint
    }
    
    func addPadding(topPadding: CGFloat, betweenTopView topView: UIView, andBottomView bottomView: UIView, andPriority priority: UILayoutPriority = 1000) -> NSLayoutConstraint{
        let topConstraint = NSLayoutConstraint(item: bottomView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: topView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: topPadding)
        topConstraint.priority = priority
        self.addConstraint(topConstraint)
        return topConstraint
    }
    
    func addPadding(padding: CGFloat, betweenLeftView leftView: UIView, andRightView rightView: UIView, andPriority priority: UILayoutPriority = 1000) -> NSLayoutConstraint{
        let leftConstraint = NSLayoutConstraint(item: rightView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: leftView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: padding)
        leftConstraint.priority = priority
        self.addConstraint(leftConstraint)
        return leftConstraint
    }
    
    func addLeftPadding(leftPadding: CGFloat, rightPadding aRightPadding: CGFloat, withSubView subView: UIView, andPriority priority: UILayoutPriority = 1000) -> Array<NSLayoutConstraint>{
        let view = Dictionary<String, UIView>.DictionaryOfVariableBindings(subView);
        let constraints : Array<NSLayoutConstraint> = NSLayoutConstraint.constraintsWithVisualFormat("|-(leftspace)-[v1]-(rightspace)-|", options: NSLayoutFormatOptions.DirectionLeftToRight, metrics: ["leftspace":NSNumber(double: Double(leftPadding)), "rightspace":NSNumber(double: Double(aRightPadding))], views: view) 
        for curConstraint in constraints{
            curConstraint.priority = priority
        }
        self.addConstraints(constraints)
        return constraints
    }
    

    func createRightPadding(rightPadding: CGFloat, withSubView subView: UIView, relationship relation: NSLayoutRelation) -> NSLayoutConstraint{
        let view = Dictionary<String,UIView>.DictionaryOfVariableBindings(subView)
        let allConstraints = NSLayoutConstraint.constraintsWithVisualFormat("[v1]-(rightspace)-|", options: NSLayoutFormatOptions.AlignAllTop, metrics: ["rightspace": String(format: "%@%f", self.getRelationString(relation), rightPadding)], views: view)
        return allConstraints[0] 
    }

    func addRightPadding(rightPadding: CGFloat, withSubView subView: UIView, andPriority priority: UILayoutPriority = 1000) -> NSLayoutConstraint{
        let rightConstraint = createRightPadding(rightPadding, withSubView: subView, relationship: NSLayoutRelation.Equal)
        rightConstraint.priority = priority
        self.addConstraint(rightConstraint)
        return rightConstraint
    }
    
    func addLeftPadding(leftPadding : CGFloat, rightPadding aRightPadding: CGFloat, topPadding aTopPadding: CGFloat, withSubView subView: UIView, andPriority priority: UILayoutPriority = 1000) -> Array<NSLayoutConstraint>{
        let views = Dictionary<String,UIView>.DictionaryOfVariableBindings(subView)
        let metrics = [ "leftspace":NSNumber(double: Double(leftPadding)), "rightspace":NSNumber(double: Double(aRightPadding))]
        let lrConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(leftspace)-[v1]-(rightspace)-|", options:[NSLayoutFormatOptions.AlignAllLeading, NSLayoutFormatOptions.AlignAllTrailing], metrics: metrics, views: views)
        for curConstraint in lrConstraints{
            curConstraint.priority = priority
        }
        self.addConstraints(lrConstraints)
        let topConstraint = createTopPadding(aTopPadding, withSubView: subView, relationship: NSLayoutRelation.Equal)
        topConstraint.priority = priority;
        self.addConstraint(topConstraint)
        return [ (lrConstraints[0] ), (lrConstraints[1] ), topConstraint ]
    }
    
// MARK: - Aligning two views
    func matchSidesForView(view1: UIView, withView view2: UIView){
        let leftConstraint =  NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view2, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0)
        let rightConstraint =  NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: view2, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0)
        let topConstraint =  NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view2, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint =  NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view2, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0)
        self.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }
    
// MARK: - Centering
    func createCenterVerticalSubView(subView: UIView, constant aConstant: CGFloat, relationship relation: NSLayoutRelation) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.CenterY, relatedBy: relation, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: aConstant)
    }

    func centerVerticalSubView(subView: UIView, constant aConstant: CGFloat) -> NSLayoutConstraint{
        let constraint = createCenterVerticalSubView(subView, constant: aConstant, relationship: NSLayoutRelation.Equal)
        self.addConstraint(constraint)
        return constraint;
    }
    
    func centerVerticalSubView(subView: UIView) -> NSLayoutConstraint{
        return centerVerticalSubView(subView, constant: 0);
    }

    func createCenterHorizontalSubView(subView: UIView, constant aConstant: CGFloat, relationship relation: NSLayoutRelation) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.CenterX, relatedBy: relation, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: aConstant)
    }

    func centerHorizontalSubView(subView : UIView) -> NSLayoutConstraint{
        let constraint = createCenterHorizontalSubView(subView, constant: 0, relationship: NSLayoutRelation.Equal);
        self.addConstraint(constraint)
        return constraint
    }
    
// MARK: - Width & Height
    func createHeight(height: CGFloat, toView view: UIView, relationship relation: NSLayoutRelation) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Height, relatedBy: relation, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: height)
    }
    
    func createWidth(width: CGFloat, toView view: UIView, relationship relation: NSLayoutRelation) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Width, relatedBy: relation, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: width)
    }
    
    func addHeight(height: CGFloat, toView view: UIView, andPriority priority: UILayoutPriority = 1000) -> NSLayoutConstraint{
        let heightConstraint = createHeight(height, toView: view, relationship: NSLayoutRelation.Equal)
        heightConstraint.priority = priority
        self.addConstraint(heightConstraint)
        return heightConstraint
    }
    
    func addWidth(width: CGFloat, toView view: UIView, andPriority priority: UILayoutPriority = 1000) -> NSLayoutConstraint{
        let widthConstraint = createWidth(width, toView: view, relationship: NSLayoutRelation.Equal)
        widthConstraint.priority = priority
        self.addConstraint(widthConstraint)
        return widthConstraint
    }

    func addWidth(width: CGFloat, andHeight height: CGFloat, toView view: UIView, andPriority priority: UILayoutPriority = 1000) -> Array<NSLayoutConstraint>{
        let widthConstraint = self.addWidth(width, toView: view, andPriority: priority)
        let heightConstraint = self.addHeight(height, toView: view, andPriority: priority)
        return [widthConstraint, heightConstraint]
    }
    
}

