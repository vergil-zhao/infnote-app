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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UIScreen.main.bounds.height / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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

