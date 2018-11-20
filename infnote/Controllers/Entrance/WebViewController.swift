//
//  WebViewController.swift
//  infnote
//
//  Created by Vergil Choi on 2018/11/20.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.load(URLRequest(url: url))
    }

}
