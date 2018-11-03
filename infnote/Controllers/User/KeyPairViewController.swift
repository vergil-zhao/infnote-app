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
        
        publicKeyLabel.text = key.compressedPublicKey.base58
        privateKeyLabel.text = key.privateKey?.base58
    }
    
    @IBAction func showButtonTouched(_ sender: UIButton) {
        privateKeyLabel.isHidden = false
        sender.isHidden = true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            UIPasteboard.general.string = key.compressedPublicKey.base58
            SVProgressHUD.showInfo(withStatus: NSLocalizedString("Key.alert.pasted", comment: ""))
        }
        else if indexPath.section == 1 {
            let sheet = UIAlertController(title: NSLocalizedString("KeyPair.saving.private.title", comment: ""), message: nil, preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: NSLocalizedString("KeyPair.saving.private.copy", comment: ""), style: .default, handler: { _ in
                UIPasteboard.general.string = self.key.privateKey!.base58
                SVProgressHUD.showInfo(withStatus: NSLocalizedString("Key.alert.pasted", comment: ""))
            }))
            sheet.addAction(UIAlertAction(title: NSLocalizedString("KeyPair.saving.private.library", comment: ""), style: .default, handler: { _ in
                var code = QRCode(self.key.privateKey!.base58)!
                code.size = CGSize(width: 500, height: 500)
                UIImageWriteToSavedPhotosAlbum(code.image!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            }))
            sheet.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil))
            present(sheet, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            SVProgressHUD.showError(withStatus: NSLocalizedString("Key.alert.save.failed", comment: ""))
        } else {
            SVProgressHUD.showInfo(withStatus: NSLocalizedString("Key.alert.saved", comment: ""))
        }
    }
}

