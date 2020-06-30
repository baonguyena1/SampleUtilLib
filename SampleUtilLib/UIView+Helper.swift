//
//  UIView+Helper.swift
//  SampleUtilLib
//
//  Created by Bao Nguyen on 2020/06/30.
//  Copyright © 2020 Bao Nguyen. All rights reserved.
//

import UIKit.UIView

public extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            if let cgColor = self.layer.borderColor {
                return UIColor(cgColor: cgColor)
            }
            return .clear
        }
        
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
}
