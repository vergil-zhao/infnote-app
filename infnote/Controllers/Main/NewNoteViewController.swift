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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil, queue: OperationQueue.main) { notification in
            if let info = notification.userInfo {
                let frame = info[UIKeyboardFrameEndUserInfoKey] as! CGRect
                let curve = info[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
                let time = info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
                UIView.animate(withDuration: time.doubleValue, delay: 0, options: UIViewAnimationOptions(rawValue: curve.uintValue), animations: {
                    self.view.bounds.size.height = frame.size.height
                }, completion: { completed in
                    
                })
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath) as! NewNoteTextCell
        return cell
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


class NewNoteTextCell: UITableViewCell {
    @IBOutlet weak var textView: UITextView!
    
    func prepareViews() {
        
    }
}
