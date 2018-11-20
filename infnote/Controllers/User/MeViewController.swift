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
    @IBOutlet weak var safeModeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        nicknameLabel.text = User.current?.nickname ?? "INFNOTE"
        idLabel.text = "@\(User.current?.id ?? "infnote")"
        
        if User.current != nil {
            logoutLabel.text = __("logout")
        }
        else {
            logoutLabel.text = __("back.to.login")
        }
        
        if let safeMode = UserDefaults.standard.value(forKey: "infnote.user.safe_mode") as? Bool {
            safeModeSwitch.isOn = safeMode
        }
    }
    
    @IBAction func safeModeSwitchChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "infnote.user.safe_mode")
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            if User.current == nil {
                Key.clean()
                User.current = nil
                AppDelegate.switchToEntranceStoryboard()
                return
            }
            
            let alert = UIAlertController(title: __("Me.logout.alert.title"), message: __("Me.logout.alert.message"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: __("Me.logout.alert.sure"), style: .destructive, handler: { _ in
                Key.clean()
                User.current = nil
                AppDelegate.switchToEntranceStoryboard()
            }))
            alert.addAction(UIAlertAction(title: __("cancel"), style: .cancel, handler: nil))
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
        if ["KeyPair", "UserView", "Notifications"].contains(identifier) {
            if User.current == nil {
                SVProgressHUD.showError(withStatus: __("login.first"))
                return false
            }
        }
        return true
    }
}
