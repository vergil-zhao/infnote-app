//
//  NewNoteViewController.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/14.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class NewNoteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        let action = { (notification: Notification) in
            if let info = notification.userInfo {
                let frame = info[UIKeyboardFrameEndUserInfoKey] as! CGRect
                let curve = info[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
                let time = info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
                
                UIView.animate(withDuration: time.doubleValue, delay: 0, options: UIViewAnimationOptions(rawValue: curve.uintValue), animations: {
                    self.bottomConstraint.constant = -frame.height
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil, queue: OperationQueue.main, using: action)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { notification in
            if let info = notification.userInfo {
                let curve = info[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
                let time = info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
                
                UIView.animate(withDuration: time.doubleValue, delay: 0, options: UIViewAnimationOptions(rawValue: curve.uintValue), animations: {
                    self.bottomConstraint.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
        
        let note = [
            "user_id": "vergil",
            "content": "Some description of blockchain",
            "date_submitted": Int(Date().timeIntervalSince1970),
            "reply_to": "3DHjJB7shUyu8x8xVrNcEdjoA6wQJA1hVxojJ3rk7iQJ"
            ] as [String : Any]
        let key = try! Key(privateKey: "7x8tbToeR2XVfn35T89bXXmxyXiJN9h6BbSnhKoYg1GcuQ4cM75ewmMpzZXr1ttMcUz4u9Wd6AjUwMcEdPfZDr3qwGY68tAuEBnXJgSCT4tv4HqPCeaiGkQW6Zr8HNioDwVJ")
        let signature = try! key.sign(data: JSONSerialization.data(withJSONObject: note, options: .sortedKeys))
        print(key.publicKey.base58)
        print(key.privateKey.base58)
        print(signature.base58)
        print(note)
    }

    @IBAction func cancelButtonTouched(_ sender: Any) {
        self.navigationController?.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath) as! NewNoteTextCell
            cell.prepareViews(tableView)
            return cell
        }
        else {
            return tableView.dequeueReusableCell(withIdentifier: "topic", for: indexPath)
        }
    }

}


class NewNoteTextCell: UITableViewCell, UITextViewDelegate {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    weak var tableView: UITableView!
    
    func prepareViews(_ tableView: UITableView) {
        self.tableView = tableView
        textView.delegate = self
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textViewHeightConstraint.constant = textView.sizeThatFits(textView.frame.size).height
        
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
}

class TopicButtonCell: UITableViewCell {
    
    @IBOutlet weak var topicButton: UIButton!
    
    func prepareViews() {
        topicButton.layer.borderColor = MAIN_COLOR.cgColor
        topicButton.layer.borderWidth = 0.5
    }
}
