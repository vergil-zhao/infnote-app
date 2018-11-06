//
//  AddPeerViewController.swift
//  InfnoteChain_Example
//
//  Created by Vergil Choi on 2018/10/22.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import InfnoteChain

class AddPeerViewController: UITableViewController {

    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var portField: UITextField!
    @IBOutlet weak var rankField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func addButtonTouched(_ sender: Any) {
        guard var address = addressField.text,
            var portString = portField.text,
            var rankString = rankField.text else {
            return
        }
        
        address = address.count <= 0 ? addressField.placeholder! : address
        portString = portString.count <= 0 ? portField.placeholder! : portString
        rankString = rankString.count <= 0 ? rankField.placeholder! : rankString

        if let port = Int(portString),
            let rank = Int(rankString),
            address.count > 0,
            port > 0 && port < 65536,
            let peer = Peer(address: address, port: port, rank: rank) {
            PeerManager.shared.addOrUpdate(peer)
            navigationController?.popViewController(animated: true)
            return
        }
        
        let alert = UIAlertController(title: nil, message: "Invalid format of peer information", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
