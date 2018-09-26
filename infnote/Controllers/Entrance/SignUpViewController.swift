//
//  SignUpViewController.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/4.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! PrivateKeyViewController
        viewController.id = idField.text
        viewController.nickname = nicknameField.text
        viewController.bio = bioTextView.text.lengthOfBytes(using: .utf8) > 0 ? bioTextView.text : nil
    }
}
