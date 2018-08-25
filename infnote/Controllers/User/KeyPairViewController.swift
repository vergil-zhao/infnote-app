//
//  KeyPairViewController.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/9.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit
import QRCode

class KeyPairViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let message = "cool".data(using: .utf8)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UIScreen.main.bounds.height / 2

        let publicKeyData = Data(hex: "042b6969edea2bcce4cace297e59b52c3eff29ba0e5b2c7a6b0fa733015d87d7e3c0731621746deb8e973acfe06a9f34f0c9d904f18a66c15508a55d52903681e3")!
        let signatureData = Data(hex: "3045022055fd71a05901081cc05b3a4122e6c7c7f2a5c2fbe17a961b48f0909dda3902f5022100b107d04f04ce4a8b51051c9e08266b8e4ed37fe44a44cf96f733cd68e2f8c023")!
        
        originalVerify(publicKeyData, signatureData)
    }
    
    func originalGenerate() {
        let attributes: [String: Any] =
            [kSecAttrKeyType as String:            kSecAttrKeyTypeECSECPrimeRandom,
             kSecAttrKeySizeInBits as String:      256,
             kSecPrivateKeyAttrs as String:
                [kSecAttrIsPermanent as String:    true,
                 kSecAttrEffectiveKeySize as String: 256]
        ]
        
        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            print(error!.takeRetainedValue() as Error)
            return
        }
        let publicKey = SecKeyCopyPublicKey(privateKey)!
        
        guard let privateKeyData = SecKeyCopyExternalRepresentation(privateKey, &error) as Data? else {
            print(error!.takeRetainedValue() as Error)
            return
        }
        
        guard let publicKeyData = SecKeyCopyExternalRepresentation(publicKey, &error) as Data? else {
            print(error!.takeRetainedValue() as Error)
            return
        }
        
        guard let signature = SecKeyCreateSignature(privateKey, .ecdsaSignatureMessageX962SHA256, message as CFData, &error) as Data? else {
            print(error!.takeRetainedValue() as Error)
            return
        }
        
        guard SecKeyVerifySignature(publicKey, .ecdsaSignatureMessageX962SHA256, message as CFData, signature as CFData, &error) else {
            print(error!.takeRetainedValue() as Error)
            return
        }
        
        print("Private Key Object: \(privateKey)")
        print("Public  Key Object: \(publicKey)")
        print("Private Key String: \(privateKeyData.hex)")
        print("Public  Key String: \(publicKeyData.hex)")
        print("Signature   String: \(signature.hex)")
        print("Signature Verified.")
    }
    
    func originalVerify(_ publicKeyData: Data, _ signatureData: Data) { 
        var error: Unmanaged<CFError>?
        let options: [String: Any] = [kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
                                      kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
                                      kSecAttrKeySizeInBits as String : 256]
        guard let key = SecKeyCreateWithData(publicKeyData as CFData,
                                             options as CFDictionary,
                                             &error) else {
                                                print(error!.takeRetainedValue() as Error)
                                                return
        }
        guard SecKeyVerifySignature(key,
                                    .ecdsaSignatureMessageX962SHA256,
                                    message as CFData,
                                    signatureData as CFData,
                                    &error) else {
                                        print(error!.takeRetainedValue() as Error)
                                        return
        }
        print("Signature Verified.")
    }
    
    @IBAction func copyButtonTouched(_ sender: Any) {
        
    }
    
    @IBAction func saveButtonTouched(_ sender: Any) {
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! KeyPairCell
        cell.prepareViews()
        return cell
    }
    
}

class KeyPairCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var qrcodeView: UIImageView!
    @IBOutlet weak var keyLabel: UILabel!
    
    func prepareViews() {
        var code = QRCode("1A6csP8jrpyruyW4a9tX9Nonv4R8AviB1y")
        
        let width = qrcodeView.bounds.width > qrcodeView.bounds.height ? qrcodeView.bounds.height : qrcodeView.bounds.width
        code?.size = CGSize(width: width, height: width)
        qrcodeView.image = code!.image
        qrcodeView.contentMode = .scaleAspectFit
    }
}

