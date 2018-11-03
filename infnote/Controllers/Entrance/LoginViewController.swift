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
    @IBOutlet weak var iCloudView: UIView!
    @IBOutlet weak var skImageView: UIImageView!
    
    var key: Key? {
        didSet {
            guard key != nil else {
                return
            }
            var code = QRCode(key!.privateKey!.base58)!
            let width = skImageView.bounds.width > skImageView.bounds.height ? skImageView.bounds.height : skImageView.bounds.width
            code.size = CGSize(width: width, height: width)
            skImageView.image = code.image
            skImageView.isHidden = false
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
        imageSKView.isHidden = sender.selectedSegmentIndex != 0
        textSKView.isHidden = sender.selectedSegmentIndex == 0
    }
    
    @IBAction func uploadTouched(_ sender: UITapGestureRecognizer) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Login.sheet.qrcode.title", comment: ""), style: .default, handler: { _ in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: NSStringFromClass(QRCodeScannerViewController.self))
            self.navigationController?.pushViewController(controller!, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Login.sheet.library.title", comment: ""), style: .default, handler: { _ in
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = .savedPhotosAlbum
            self.present(controller, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil))
        self.present(actionSheet, animated: true)
    }
    
    @IBAction func pasteTouched(_ sender: UITapGestureRecognizer) {
        if UIPasteboard.general.hasStrings {
            if let key = try? Key(privateKey: UIPasteboard.general.string!) {
                self.key = key
            }
        }
        else {
            let alert = UIAlertController(title: NSLocalizedString("Login.alert.paste.title", comment: ""), message: NSLocalizedString("Login.alert.paste.message", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .cancel, handler: nil))
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
                if let key = try? Key(privateKey: feature.messageString!) {
                    self.key = key
                }
            }
        }
        
        picker.dismiss(animated: true)
    }
    
    @IBAction func loginButtonTouched(_ sender: Any) {
        if let key = self.key {
            SVProgressHUD.show()
            Networking.shared.fetchUser(publicKey: key.compressedPublicKey.base58, complete: { user in
                SVProgressHUD.dismiss()
                user.key = key
                user.save()
                AppDelegate.switchToMainStoryboard()
            }, failed: { _ in
                SVProgressHUD.showError(withStatus: NSLocalizedString("Login.alert.failed.title", comment: ""))
            })
        }
        else {
            SVProgressHUD.showError(withStatus: NSLocalizedString("Login.alert.key.title", comment: ""))
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
