//
//  PrivateKeyViewController.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/4.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit
import QRCode

class PrivateKeyViewController: UIViewController {

    @IBOutlet weak var iCloudView: UIView!
    @IBOutlet weak var privateKeyQRCodeView: UIImageView!
    @IBOutlet weak var privateKeyLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    
    let key = try! Key()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        privateKeyLabel.text = key.privateKey.base58
        userIDLabel.text = key.publicKey.data.sha256.base58
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = iCloudView.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.6549019608, green: 0.6862745098, blue: 0.9019607843, alpha: 1).cgColor, #colorLiteral(red: 0.9450980392, green: 0.7529411765, blue: 0.9254901961, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0.0, 1.0]
        iCloudView.layer.insertSublayer(gradientLayer, at: 0)
        iCloudView.layer.masksToBounds = true
        
        var code = QRCode(key.privateKey.base58)!
        let width = privateKeyQRCodeView.bounds.width > privateKeyQRCodeView.bounds.height ? privateKeyQRCodeView.bounds.height : privateKeyQRCodeView.bounds.width
        code.size = CGSize(width: width, height: width)
        privateKeyQRCodeView.image = code.image
    }
    
    @IBAction func doneButtonTouched(_ sender: Any) {
        try! key.save()
        AppDelegate.switchToMainStoryboard()
    }
}
