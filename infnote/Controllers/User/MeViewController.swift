//
//  MeViewController.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/16.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit
import InfnoteChain
import SVProgressHUD

class MeViewController: UITableViewController {

    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var logoutLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        nicknameLabel.text = User.current?.nickname ?? "INFNOTE"
        idLabel.text = "@\(User.current?.id ?? "infnote")"
        
        if User.current != nil {
            logoutLabel.text = NSLocalizedString("logout", comment: "")
        }
        else {
            logoutLabel.text = NSLocalizedString("back.to.login", comment: "")
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            if User.current == nil {
                Key.clean()
                AppDelegate.switchToEntranceStoryboard()
                return
            }
            
            let alert = UIAlertController(title: NSLocalizedString("Me.logout.alert.title", comment: ""), message: NSLocalizedString("Me.logout.alert.message", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Me.logout.alert.sure", comment: ""), style: .destructive, handler: { _ in
                Key.clean()
                AppDelegate.switchToEntranceStoryboard()
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil))
            present(alert, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserView" {
            let controller = segue.destination as! UserViewController
            controller.user = User.current!
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "KeyPair" {
            if User.current == nil {
                SVProgressHUD.showError(withStatus: NSLocalizedString("login.first", comment: ""))
                return false
            }
        }
        return true
    }
}
