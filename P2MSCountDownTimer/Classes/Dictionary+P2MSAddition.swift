//
//  Dictionary+P2MSAddition.swift
//  P2MSCircularBreadCrumbView
//
//  Created by Pyae Phyo Myint Soe on 1/9/15.
//  Copyright (c) 2015 PYAE PHYO MYINT SOE. All rights reserved.
//

import Foundation
import UIKit

extension Dictionary{
    static func DictionaryOfVariableBindings(views: UIView...) -> Dictionary<String, UIView>{
        var newDictionary = Dictionary<String, UIView>();
        for (index,value) in views.enumerate(){
            newDictionary["v\(index+1)"] = value
        }
        return newDictionary
    }
}