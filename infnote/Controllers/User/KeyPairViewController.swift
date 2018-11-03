//
//  KeyPairViewController.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/9.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit
import QRCode
import InfnoteChain

class KeyPairViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let key = Key.loadDefaultKey()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UIScreen.main.bounds.height / 2

    }
    
    @IBAction func copyButtonTouched(_ sender: Any) {
        
    }
    
    @IBAction func saveButtonTouched(_ sender: Any) {
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return key == nil ? 0 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! KeyPairCell
        if indexPath.row == 0 {
            cell.prepareViews(title: NSLocalizedString("key.private", comment: ""), key: key!.privateKey!.base58)
        }
        else if indexPath.row == 1 {
            cell.prepareViews(title: NSLocalizedString("key.public", comment: ""), key: key!.compressedPublicKey.base58)
        }
        return cell
    }
    
}

class KeyPairCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var qrcodeView: UIImageView!
    @IBOutlet weak var keyLabel: UILabel!
    
    func prepareViews(title: String, key: String) {
        titleLabel.text = title
        keyLabel.text = key
        
        var code = QRCode(key)!
        let width = qrcodeView.bounds.width > qrcodeView.bounds.height ? qrcodeView.bounds.height : qrcodeView.bounds.width
        code.size = CGSize(width: width, height: width)
        qrcodeView.image = code.image
        qrcodeView.contentMode = .scaleAspectFit
    }
}

