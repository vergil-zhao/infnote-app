//
//  UIView+Shadow.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/1.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit


extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var maskToBounds: Bool {
        get {
            return self.layer.masksToBounds
        }
        set {
            self.layer.masksToBounds = newValue
        }
    }
    
    @IBInspectable var shadow: Bool {
        get {
            return self.layer.shadowOpacity > 0
        }
        set {
            if newValue {
                self.layer.shadowColor = UIColor.lightGray.cgColor
                self.layer.shadowRadius = 8
                self.layer.shadowOpacity = 0.3
                self.layer.shadowOffset = CGSize.zero
            } else {
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor = nil
            }
        }
    }
}
