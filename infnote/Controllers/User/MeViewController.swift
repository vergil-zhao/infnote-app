//
//  MeViewController.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/16.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit

class MeViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }


}
