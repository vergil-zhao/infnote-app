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
import SVProgressHUD

class KeyPairViewController: UITableViewController {
    
    let key = Key.loadDefaultKey()!
    
    @IBOutlet weak var publicKeyLabel: UILabel!
    @IBOutlet weak var privateKeyLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        publicKeyLabel.text = key.address
        privateKeyLabel.text = key.wif
    }
    
    @IBAction func showButtonTouched(_ sender: UIButton) {
        privateKeyLabel.isHidden = false
        sender.isHidden = true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            Export.copyToPastboard(key: key.address)
        }
        else if indexPath.section == 1 {
            let sheet = UIAlertController(title: __("KeyPair.saving.private.title"), message: nil, preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: __("KeyPair.saving.private.copy"), style: .default, handler: { _ in
                Export.copyToPastboard(key: self.key.wif)
            }))
            sheet.addAction(UIAlertAction(title: __("KeyPair.saving.private.library"), style: .default, handler: { _ in
                Export.shared.saveKeyToPhotoLibrary()
            }))
            sheet.addAction(UIAlertAction(title: __("cancel"), style: .cancel, handler: nil))
            present(sheet, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

