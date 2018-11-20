//
//  ReportViewController.swift
//  infnote
//
//  Created by Vergil Choi on 2018/11/20.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit
import SVProgressHUD

class ReportViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
            }
            else {
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
        }
        else if indexPath.section == 1 {
            
        }
        else if indexPath.section == 2 {
            navigationController?.popViewController(animated: true)
            SVProgressHUD.showInfo(withStatus: __("Report.submit.succeed"))
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
