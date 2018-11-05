//
//  HomeViewController.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/2.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = User.current != nil
    }
    
}
