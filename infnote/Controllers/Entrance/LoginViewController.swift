//
//  LoginViewController.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/1.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit
import ImagePicker

class LoginViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageSKView: UIView!
    @IBOutlet weak var textSKView: UIView!
    @IBOutlet weak var iCloudView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        prepareViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segementedControlChanged(_ sender: UISegmentedControl) {
        imageSKView.isHidden = sender.selectedSegmentIndex != 0
        textSKView.isHidden = sender.selectedSegmentIndex == 0
    }
    
    @IBAction func uploadTouched(_ sender: UITapGestureRecognizer) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "扫描二维码", style: .default, handler: { _ in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: NSStringFromClass(QRCodeScannerViewController.self))
            self.navigationController?.pushViewController(controller!, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "从图库中选取", style: .default, handler: { _ in
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = .savedPhotosAlbum
            self.present(controller, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true)
    }
    
    @IBAction func pasteTouched(_ sender: UITapGestureRecognizer) {
        if UIPasteboard.general.hasStrings {
            
        }
        else {
            let alert = UIAlertController(title: "提示", message: "剪贴板中无内容，请复制后再次尝试", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "好", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true)
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
