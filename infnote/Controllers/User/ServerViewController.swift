//
//  ServerViewController.swift
//  infnote
//
//  Created by Vergil Choi on 2018/11/3.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit

class ServerViewController: UITableViewController {

    @IBOutlet weak var addressTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            Networking.shared.host = addressTextField.text ?? ""
            navigationController?.popViewController(animated: true)
        }
    }

}
