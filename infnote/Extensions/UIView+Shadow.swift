//
//  UIView+Shadow.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/1.
//  Copyright © 2018年 Vergil Choi. All rights reserved.
//

import UIKit

extension UIView {
    func addCorner() {
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
    
    func addShadow() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = 8
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize.zero
    }
}
