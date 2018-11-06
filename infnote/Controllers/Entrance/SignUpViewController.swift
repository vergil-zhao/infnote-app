//
//  SignUpViewController.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/4.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit
import InfnoteChain
import SVProgressHUD

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var nicknameField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        nextButton.isEnabled = false
        nextButton.backgroundColor = .gray
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        if let _ = idField.text?.range(of: "^[a-zA-Z0-9_-]{1,30}$", options: .regularExpression, range: nil, locale: nil),
            let _ = nicknameField.text?.range(of: ".{1,30}", options: .regularExpression, range: nil, locale: nil) {
            nextButton.isEnabled = true
            nextButton.backgroundColor = MAIN_COLOR
        }
        else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = .gray
        }
    }
    
    @IBAction func nextButtonTouched(_ sender: Any) {
        guard let id = idField.text, let nickname = nicknameField.text,
            id.count > 0 && nickname.count > 0 else {
            SVProgressHUD.showError(withStatus: __("SignUp.error.user.input"))
            return
        }
        
        let key = try! Key()
        var info = [
            "id": id,
            "nickname": nickname
        ]
        if let bio = bioTextView.text.count > 0 ? bioTextView.text : nil {
            info["bio"] = bio
        }
        let data = try! JSONSerialization.data(withJSONObject: info, options: .sortedKeys)
        let signatureData = try! key.sign(data: data)
        let user = User(JSON: info)!
        user.signature = signatureData.base58
        user.publicKey = key.compressedPublicKey.base58
        user.key = key
        
        SVProgressHUD.show()
        Networking.shared.create(user: user, complete: { _ in
            SVProgressHUD.dismiss()
            key.save()
            User.current = user
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: NSStringFromClass(PrivateKeyViewController.self)) as? PrivateKeyViewController else {
                return
            }
            controller.key = key
            self.navigationController?.pushViewController(controller, animated: true)
        }) { error in
            print(error)
            SVProgressHUD.showError(withStatus: __("SignUp.user.create.failed"))
        }
    }
    
}
