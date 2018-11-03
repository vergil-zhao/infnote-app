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
import SVProgressHUD
import CRRefresh

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

class NoteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var note: Note!
    var comments: [Note] = []
    var page = 1
    var tableViewContentOffsetObservation: NSKeyValueObservation!
    
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentTextViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        tableView.register(MainCell.self, forCellReuseIdentifier: "note")
        tableView.register(CommentCell.self, forCellReuseIdentifier: "comment")
        tableView.estimatedRowHeight = 100
        textViewDidChange(commentTextView)
        
        Networking.shared.fetchNote(id: note.id, complete: { note in
            self.note = note
            self.tableView.reloadData()
        }) { error in
            print(error)
        }
        
        tableView.cr.addHeadRefresh { [unowned self] in
            self.reload()
        }
        tableView.cr.addFootRefresh { [unowned self] in
            self.page += 1
            Networking.shared.fetchReplyList(noteID: self.note.id, page: self.page, complete: { notes in
                if notes.count == 0 {
                    self.tableView.cr.noticeNoMoreData()
                }
                self.comments += notes
                self.tableView.reloadData()
                self.tableView.cr.endLoadingMore()
            }, failed: { error in
                self.tableView.cr.endLoadingMore()
                print(error)
            })
        }
        self.reload()
        
        tableViewContentOffsetObservation = tableView.observe(\UITableView.contentOffset) { _, _ in
            self.commentTextView.resignFirstResponder()
        }
    }
    
    func reload() {
        page = 1
        tableView.cr.resetNoMore()
        Networking.shared.fetchReplyList(noteID: self.note.id, complete: { notes in
            self.comments = notes
            self.tableView.reloadData()
            self.tableView.cr.endHeaderRefresh()
        }, failed: { error in
            self.tableView.cr.endHeaderRefresh()
            print(error)
        })
    }
    
    deinit {
        tableViewContentOffsetObservation.invalidate()
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
            return comments.count
        default:
            return 0
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "note", for: indexPath) as! MainCell
            cell.prepareViews(note: note!)
            cell.contentLabel.numberOfLines = 0
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as! CommentCell
            cell.prepareViews(note: comments[indexPath.row])
            return cell
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "添加评论" {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "添加评论"
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        commentTextViewHeightConstraint.constant = textView.sizeThatFits(textView.frame.size).height
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            var data = [
                "content": textView.text,
                "date_submitted": Int(Date().timeIntervalSince1970),
                "user_id": User.current!.id,
                "reply_to": note!.id
                ] as [String: Any]
            let signature = try! User.current!.key!.sign(data: JSONSerialization.data(withJSONObject: data, options: .sortedKeys))
            data["signature"] = signature.base58
            SVProgressHUD.show()
            Networking.shared.create(note: data, complete: { note in
                textView.text = ""
                textView.resignFirstResponder()
                SVProgressHUD.showInfo(withStatus: "发布成功")
                self.tableView.cr.beginHeaderRefresh()
            }, failed: { error in
                SVProgressHUD.showError(withStatus: "发布失败")
            })
            return false
        }
        return true
    }
}
