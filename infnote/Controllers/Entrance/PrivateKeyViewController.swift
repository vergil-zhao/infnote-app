//
//  PrivateKeyViewController.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/4.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit
import QRCode
import SVProgressHUD

class PrivateKeyViewController: UIViewController {

    @IBOutlet weak var iCloudView: UIView!
    @IBOutlet weak var privateKeyQRCodeView: UIImageView!
    @IBOutlet weak var privateKeyLabel: UILabel!
    @IBOutlet weak var publicKeyLabel: UILabel!
    
    var id: String!
    var nickname: String!
    var bio: String?
    
    let key = try! Key()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        privateKeyLabel.text = key.privateKey.base58
        publicKeyLabel.text = key.publicKey.base58
        
        /* Test signature procedure
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
         */
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
    
    @IBAction func saveButtonTouched(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(privateKeyQRCodeView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func privateKeyLabelTouched(_ sender: Any) {
        UIPasteboard.general.string = key.privateKey.base58
        SVProgressHUD.showInfo(withStatus: "已复制到剪贴板")
    }
    
    @IBAction func publicKeyLabelTouched(_ sender: Any) {
        UIPasteboard.general.string = key.publicKey.base58
        SVProgressHUD.showInfo(withStatus: "已复制到剪贴板")
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            SVProgressHUD.showError(withStatus: "保存失败")
        } else {
            SVProgressHUD.showInfo(withStatus: "已保存至手机相册")
        }
    }
    
    @IBAction func doneButtonTouched(_ sender: Any) {
        var info = [
            "id": id!,
            "nickname": nickname!
        ]
        if let bio = self.bio {
            info["bio"] = bio
        }
        let data = try! JSONSerialization.data(withJSONObject: info, options: .sortedKeys)
        let signatureData = try! key.sign(data: data)
        let user = User(JSON: info)!
        user.signature = signatureData.base58
        user.publicKey = key.publicKey.base58
        user.key = key
        
        SVProgressHUD.show()
        Networking.shared.create(user: user, complete: { user in
            SVProgressHUD.dismiss()
            user.save()
            AppDelegate.switchToMainStoryboard()
        }, failed: { error in
            SVProgressHUD.showError(withStatus: "注册用户失败")
        })
    }
}
