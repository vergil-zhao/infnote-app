//
//  MeViewController.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/16.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit
import InfnoteChain

class MeViewController: UITableViewController {

    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        nicknameLabel.text = User.current?.nickname ?? "INFNOTE"
        idLabel.text = "@\(User.current?.id ?? "infnote")"
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            let alert = UIAlertController(title: "退出登录", message: "将会清除本地保存的私钥，再次登录需要重新导入", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "继续退出", style: .destructive, handler: { _ in
                Key.clean()
                AppDelegate.switchToEntranceStoryboard()
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
