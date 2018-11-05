//
//  HomeViewController.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/2.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import CRRefresh

class NoteFlowViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, IndicatorInfoProvider {
    
    @IBOutlet weak var tableView: UITableView!
    
    var page = 1
    var notes: [Note] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MainCell.self, forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 365
        tableView.tableFooterView = UIView()
        tableView.cr.addHeadRefresh { [unowned self] in
            self.reload()
        }
        tableView.cr.addFootRefresh {
            self.page += 1
            Networking.shared.fetchNoteList(page: self.page, complete: { [unowned self] notes in
                self.tableView.cr.endLoadingMore()
                if notes.count <= 0 {
                    self.tableView.cr.noticeNoMoreData()
                    return
                }
                self.notes.append(contentsOf: notes)
                self.tableView.reloadData()
                }, failed: { error in
                    self.tableView.cr.endLoadingMore()
            })
        }
        self.reload()
    }
    
    func reload() {
        tableView.cr.resetNoMore()
        page = 1
        Networking.shared.fetchNoteList(page: 1, complete: { notes in
            self.notes = notes
            self.tableView.reloadData()
            self.tableView.cr.endHeaderRefresh()
        }, failed: { error in
            self.tableView.cr.endHeaderRefresh()
        })
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
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = storyboard!.instantiateViewController(withIdentifier: NSStringFromClass(NoteViewController.self)) as! NoteViewController
        controller.note = notes[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "话题")
    }
}
