//
//  LoginViewController.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/1.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit
import ImagePicker
import QRCode
import SVProgressHUD
import InfnoteChain

class LoginViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageSKView: UIView!
    @IBOutlet weak var textSKView: UIView!
    @IBOutlet weak var iCloudSKView: UIView!
    @IBOutlet weak var iCloudView: UIView!
    
    @IBOutlet weak var imageTitleLabel: UILabel!
    @IBOutlet weak var imageSubtitleLabel: UILabel!
    @IBOutlet weak var textTitleLabel: UILabel!
    @IBOutlet weak var textSubtitleLabel: UILabel!
    @IBOutlet weak var iCloudTitleLabel: UILabel!
    @IBOutlet weak var iCloudSubtitleLabel: UILabel!
    
    @IBOutlet weak var iCloudSwitch: UISwitch!
    
    var key: Key? {
        didSet {
            guard key != nil else {
                SVProgressHUD.showError(withStatus: __("key.error"))
                return
            }
            
            SVProgressHUD.show()
            Networking.shared.fetchUser(id: key!.address, complete: { user in
                SVProgressHUD.dismiss()
                user.key = self.key
                self.user = user
            }) { error in
                print(error)
                SVProgressHUD.showError(withStatus: __("Login.error.user.failed"))
            }
        }
    }
    
    var user: User? {
        didSet {
            guard user != nil else {
                return
            }
            imageTitleLabel.text = user!.nickname
            imageSubtitleLabel.text = "\(user!.id!)"
            textTitleLabel.text = user!.nickname
            textSubtitleLabel.text = "\(user!.id!)"
            iCloudTitleLabel.text = user!.nickname
            iCloudSubtitleLabel.text = "\(user!.id!)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        prepareViews()
    }
    
    @IBAction func segementedControlChanged(_ sender: UISegmentedControl) {
        imageSKView.isHidden   = sender.selectedSegmentIndex != 0
        textSKView.isHidden    = sender.selectedSegmentIndex != 1
        iCloudSKView.isHidden  = sender.selectedSegmentIndex != 2
    }
    
    @IBAction func uploadTouched(_ sender: UITapGestureRecognizer) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: __("Login.sheet.qrcode.title"), style: .default, handler: { _ in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: NSStringFromClass(QRCodeScannerViewController.self)) as! QRCodeScannerViewController
            controller.complete = { [unowned self] in self.key = Key(wif: $0) }
            self.navigationController?.pushViewController(controller, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: __("Login.sheet.library.title"), style: .default, handler: { _ in
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = .savedPhotosAlbum
            self.present(controller, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: __("cancel"), style: .cancel, handler: nil))
        self.present(actionSheet, animated: true)
    }
    
    @IBAction func pasteTouched(_ sender: UITapGestureRecognizer) {
        if UIPasteboard.general.hasStrings, let key = Key(wif: UIPasteboard.general.string!) {
            self.key = key
        } else {
            let alert = UIAlertController(title: __("Login.alert.paste.title"), message: __("Login.alert.paste.message"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: __("ok"), style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func iCoundImportTouched(_ sender: UITapGestureRecognizer) {
        if let wif = NSUbiquitousKeyValueStore().string(forKey: "com.infnote.icloud.wif"),
            let key = Key(wif: wif) {
            self.key = key
        } else {
            let alert = UIAlertController(title: __("Login.alert.icloud.title"), message: __("Login.alert.icloud.message"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: __("ok"), style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let image = CIImage(image: image)!
            let context = CIContext(options: nil)
            let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
            let features = detector?.features(in: image)
            if let feature = features?.first as? CIQRCodeFeature {
                if let key = Key(wif: feature.messageString!) {
                    self.key = key
                }
            }
        }
        
        picker.dismiss(animated: true)
    }
    
    @IBAction func loginButtonTouched(_ sender: Any) {
        if let user = self.user {
            user.key?.save()
            User.current = user
            if iCloudSwitch.isOn {
                let icloud = NSUbiquitousKeyValueStore()
                icloud.set(key!.wif, forKey: "com.infnote.icloud.wif")
                icloud.synchronize()
            }
            AppDelegate.switchToMainStoryboard()
        }
        else {
            SVProgressHUD.showError(withStatus: __("Login.alert.key.title"))
        }
    }
    
    
    func prepareViews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = iCloudView.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.6549019608, green: 0.6862745098, blue: 0.9019607843, alpha: 1).cgColor, #colorLiteral(red: 0.9450980392, green: 0.7529411765, blue: 0.9254901961, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0.0, 1.0]
        iCloudView.layer.insertSublayer(gradientLayer, at: 0)
        iCloudView.layer.masksToBounds = true
    }

}

