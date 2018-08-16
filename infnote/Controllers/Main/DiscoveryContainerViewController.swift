//
//  DiscoveryContainerViewController.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/11.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit

class DiscoveryContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

}
