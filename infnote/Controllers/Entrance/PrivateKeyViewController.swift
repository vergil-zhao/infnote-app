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
    
    let key = try! Key(privateKey: "7x8tbToeR2XVfn35T89bXXmxyXiJN9h6BbSnhKoYg1GcuQ4cM75ewmMpzZXr1ttMcUz4u9Wd6AjUwMcEdPfZDr3qwGY68tAuEBnXJgSCT4tv4HqPCeaiGkQW6Zr8HNioDwVJ")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        privateKeyLabel.text = key.privateKey.base58
        userIDLabel.text = key.publicKey.base58
        
        let dict = [
            "id": "vergil",
            "nickname": "Vergil",
            "gender": 1,
            "email": "gameboy0824@126.com",
            "bio": "Be Cool"
            ] as [String : Any]
        let data = try! JSONSerialization.data(withJSONObject: dict, options: .sortedKeys)
        let signatureData = try! key.sign(data: data)
        print(String(data: data, encoding: .utf8)!)
        print(key.publicKey.base58)
        print(signatureData.base58)
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
