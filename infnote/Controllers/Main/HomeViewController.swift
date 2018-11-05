//
//  HomeViewController.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/2.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit
import RxCocoa

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = User.status.takeUntil(rx.deallocated).subscribe(onNext: { [unowned self] user in
            self.navigationItem.rightBarButtonItem?.isEnabled = user != nil
        })
    }
}
