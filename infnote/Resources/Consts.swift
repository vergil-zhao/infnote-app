//
//  Consts.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/2.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit

let DEFAULT_FONT_ULTRA_LIGHT    = "AvenirNext-UltraLight"
let DEFAULT_FONT_REGULAR        = "AvenirNext-Regular"
let DEFAULT_FONT_MEDIUM         = "AvenirNext-Medium"
let DEFAULT_FONT_DEMI_BOLD      = "AvenirNext-DemiBold"
let DEFAULT_FONT_BOLD           = "AvenirNext-Bold"


let MAIN_COLOR = #colorLiteral(red: 0.368627451, green: 0.431372549, blue: 0.9333333333, alpha: 1)


struct ViewConst {
    static let verticalMargin = CGFloat(10.0)
    static let horizontalMargin = CGFloat(15.0)
    static let lineSpace = CGFloat(8.0)
    static var safeAreaHeight: CGFloat {
        var insetHeight = CGFloat(20)
        if #available(iOS 11.0, *) {
            insetHeight = (UIApplication.shared.keyWindow?.safeAreaInsets.top)!
        }
        if insetHeight < 20 {
            insetHeight = 20
        }
        return insetHeight
    }
}
