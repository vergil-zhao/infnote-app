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
    var page = 1
    var notes: [Note] = []
    var user: User!
    
    var tableViewOffsetObservation: NSKeyValueObservation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets.zero
        tableView.register(MainCell.self, forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 365
        tableView.tableFooterView = UIView()
        
        prepareViews()
        
        tableView.cr.addHeadRefresh {
            self.reload()
        }
        tableView.cr.addFootRefresh {
            self.page += 1
            Networking.shared.fetchNoteList(user: self.user, page: self.page, complete: { notes in
                self.notes += notes
                self.tableView.reloadData()
                if notes.count == 0 {
                    self.tableView.cr.noticeNoMoreData()
                }
                self.tableView.cr.endLoadingMore()
            }, failed: { error in
                self.tableView.cr.endLoadingMore()
            })
        }
        self.reload()
    }
    
    func reload() {
        page = 1
        tableView.cr.resetNoMore()
        Networking.shared.fetchNoteList(user: user, complete: { notes in
            self.notes = notes
            self.tableView.reloadData()
            self.tableView.cr.endHeaderRefresh()
        }, failed: { error in
            self.tableView.cr.endHeaderRefresh()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    deinit {
        tableViewOffsetObservation.invalidate()
    }
    
    @objc func backButtonTouched() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func editButtonTouched() {
        navigationController?.pushViewController(storyboard!.instantiateViewController(withIdentifier: NSStringFromClass(ProfileEditViewController.self)), animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainCell
        cell.prepareViews(note: notes[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: NSStringFromClass(NoteViewController.self)) as! NoteViewController
        controller.note = notes[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func prepareViews() {
        
        let view = UserHeaderView()
        view.prepareViews(with: user)
        view.editButton.addTarget(self, action: #selector(editButtonTouched), for: .touchUpInside)
        tableView.tableHeaderView = view
        
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
        nameLabel.text = user.nickname
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
}
