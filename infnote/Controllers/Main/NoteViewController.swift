//
//  PostViewController.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/8.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit
import Down
import SnapKit

class NoteViewCell: UITableViewCell {
    func prepareViews(_ model: Any) {
        fatalError("\(type(of: self)) does not implement this abstract function.")
    }
}

class UserInfoCell: NoteViewCell {
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
}

class ContentCell: NoteViewCell {
    @IBOutlet weak var contentLabel: UILabel!
}

class NoteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        tableView.register(MainCell.self, forCellReuseIdentifier: "note")
        tableView.register(CommentCell.self, forCellReuseIdentifier: "comment")
        tableView.estimatedRowHeight = 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 10
        default:
            return 0
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "note", for: indexPath) as! MainCell
            cell.prepareViews()
            cell.contentLabel.numberOfLines = 0
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as! CommentCell
            cell.prepareViews()
            return cell
        }
    }
}
