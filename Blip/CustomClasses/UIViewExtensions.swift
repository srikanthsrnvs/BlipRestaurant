//
//  UIViewExtensions.swift
//  Blip
//
//  Created by Srikanth Srinivas on 3/1/18.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    func ApplyOuterShadowToView(){
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 3
    }
    
    func ApplyCornerRadiusToView(){
        self.layer.cornerRadius = 7
        self.clipsToBounds = true
    }
}
