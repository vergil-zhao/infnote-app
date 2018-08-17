//
//  UserNotificationViewController.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/17.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit

class UserNotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "follow", for: indexPath)
        }
        else if indexPath.row == 1 {
            return tableView.dequeueReusableCell(withIdentifier: "like", for: indexPath)
        }
        else {
            return tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath)
        }
    }
    
}
