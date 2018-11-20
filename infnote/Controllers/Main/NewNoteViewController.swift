//
//  NewNoteViewController.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/14.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SVProgressHUD

class NewNoteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var titleTextField: UITextField!
    var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let action = { (notification: Notification) in
            if let info = notification.userInfo {
                let frame = info[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                let curve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber
                let time = info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
                
                UIView.animate(withDuration: time.doubleValue, delay: 0, options: UIView.AnimationOptions(rawValue: curve.uintValue), animations: {
                    self.bottomConstraint.constant = -frame.height
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: OperationQueue.main, using: action)
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main) { notification in
            if let info = notification.userInfo {
                let curve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber
                let time = info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
                
                UIView.animate(withDuration: time.doubleValue, delay: 0, options: UIView.AnimationOptions(rawValue: curve.uintValue), animations: {
                    self.bottomConstraint.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    @IBAction func sendButtonTouched(_ sender: Any) {
        guard textView.textColor != UIColor.lightGray else {
            SVProgressHUD.showError(withStatus: __("Note.new.error.content"))
            return
        }
        guard let title = titleTextField.text, !title.isEmpty else {
            SVProgressHUD.showError(withStatus: __("Note.new.error.title"))
            return
        }
        
        var data = [
            "title": title,
            "content": textView.text,
            "date_submitted": Int(Date().timeIntervalSince1970),
            "user_id": User.current!.id,
            "nsfw": (tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! NSFWCell).nsfwSwitch.isOn
        ] as [String: Any]
        let signature = try! User.current!.key!.sign(data: JSONSerialization.data(withJSONObject: data, options: .sortedKeys))
        data["signature"] = signature.base58
        Networking.shared.create(note: data, complete: { note in
            SVProgressHUD.showInfo(withStatus: __("Note.new.succeed"))
            self.dismiss(animated: true)
        }, failed: { error in
            SVProgressHUD.showError(withStatus: __("Note.new.failed"))
        })
    }
    
    @IBAction func cancelButtonTouched(_ sender: Any) {
        self.navigationController?.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "content", for: indexPath) as! NewNoteTextCell
            cell.prepareViews(tableView)
            textView = cell.textView
            return cell
        }
        else {
            return tableView.dequeueReusableCell(withIdentifier: "nsfw", for: indexPath)
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
        textView.textColor = .lightGray
        textView.text = __("Note.new.content.placeholder")
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textViewHeightConstraint.constant = textView.sizeThatFits(textView.frame.size).height
        
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = __("Note.new.content.placeholder")
            textView.textColor = .lightGray
        }
    }
}

class TopicButtonCell: UITableViewCell {
    
    @IBOutlet weak var topicButton: UIButton!
    
    func prepareViews() {
        topicButton.layer.borderColor = MAIN_COLOR.cgColor
        topicButton.layer.borderWidth = 0.5
    }
}

class NSFWCell: UITableViewCell {
    
    @IBOutlet weak var nsfwSwitch: UISwitch!
    
}
