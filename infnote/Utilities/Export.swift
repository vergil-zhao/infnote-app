//
//  QRCode.swift
//  infnote
//
//  Created by Vergil Choi on 2018/11/5.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit
import SVProgressHUD
import QRCode

class Export: NSObject {
    static var shared = Export()
    
    override private init() {}
    
    static func copyToPastboard(key: String) {
        UIPasteboard.general.string = key
        SVProgressHUD.showInfo(withStatus: __("Key.alert.pasted"))
    }
    
    func saveKeyToPhotoLibrary(user: User! = User.current, with title: String = __("key.private")) {
        guard user != nil else {
            return
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 1200, height: 1400))
        view.backgroundColor = .white
        
        var qrcode = QRCode(user.key!.wif)
        qrcode?.size = CGSize(width: 500, height: 500)
        let codeView = UIImageView(image: qrcode?.image)
        codeView.frame = CGRect(x: 100, y: view.frame.height - 1100, width: 1000, height: 1000)
        view.addSubview(codeView)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont(name: DEFAULT_FONT_BOLD, size: 60)!
        titleLabel.textColor = .black
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint(x: view.center.x, y: 120.0)
        view.addSubview(titleLabel)
        
        let nicknameLabel = UILabel()
        nicknameLabel.text = user.nickname
        nicknameLabel.font = UIFont(name: DEFAULT_FONT_REGULAR, size: 40)!
        nicknameLabel.textColor = .black
        nicknameLabel.minimumScaleFactor = 0.5
        nicknameLabel.textAlignment = .center
        
        let idLabel = UILabel()
        idLabel.text = "@\(user.id!)"
        idLabel.font = UIFont(name: DEFAULT_FONT_REGULAR, size: 40)!
        idLabel.textColor = .gray
        idLabel.minimumScaleFactor = 0.5
        idLabel.textAlignment = .center
        
        let stack = UIStackView(arrangedSubviews: [nicknameLabel, idLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.frame = CGRect(x: 100, y: titleLabel.frame.origin.y + 120, width: 1000, height: 50)
        view.addSubview(stack)
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndPDFContext()
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            SVProgressHUD.showError(withStatus: __("Key.alert.save.failed"))
        } else {
            SVProgressHUD.showInfo(withStatus: __("Key.alert.saved"))
        }
    }

}
