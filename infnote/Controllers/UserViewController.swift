//
//  MeViewController.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/2.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit
import SnapKit

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let topbar = UIView()
    
    var tableViewOffsetObservation: NSKeyValueObservation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        tableView.contentInset = UIEdgeInsets.zero
        tableView.register(MainCell.self, forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 365
        
        let view = UserHeaderView()
        view.prepareViews()
        tableView.tableHeaderView = view
        
        prepareViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        tableViewOffsetObservation.invalidate()
    }
    
    @objc func backButtonTouched() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainCell
        cell.prepareViews()
        return cell
    }
    
    func prepareViews() {
        self.view.addSubview(topbar)
        
        tableView.contentInset = UIEdgeInsets(top: -ViewConst.safeAreaHeight, left: 0, bottom: 0, right: 0)
        
        
        topbar.backgroundColor = .clear
        topbar.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.top)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(40 + ViewConst.safeAreaHeight)
        }
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(#imageLiteral(resourceName: "left-arrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTouched), for: .touchUpInside)
        topbar.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(50)
        }
        
        let nameLabel = UILabel()
        nameLabel.text = "Vergil Choi"
        nameLabel.font = UIFont(name: DEFAULT_FONT_BOLD, size: 14)
        nameLabel.textAlignment = .center
        nameLabel.lineBreakMode = .byTruncatingMiddle
        nameLabel.alpha = 0
        topbar.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().offset(50 + 10)
        }
        
        tableViewOffsetObservation = tableView.observe(\UITableView.contentOffset, options: [.new]) { [unowned self] tableview, value in
            if let point = value.newValue {
                var alpha = point.y / (UIScreen.main.bounds.height * 0.35) - 0.35
                if alpha > 1 {
                    alpha = 1
                }
                self.topbar.backgroundColor = UIColor(white: 1, alpha: alpha)
                nameLabel.alpha = alpha
            }
        }
    
        
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
