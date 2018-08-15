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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
