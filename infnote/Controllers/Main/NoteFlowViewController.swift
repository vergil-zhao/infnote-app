//
//  HomeViewController.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/2.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class NoteFlowViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, IndicatorInfoProvider {
    
    @IBOutlet weak var tableView: UITableView!
    
    var notes: [Note] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.present(UIStoryboard.init(name: "Entrance", bundle: Bundle.main).instantiateViewController(withIdentifier: NSStringFromClass(LaunchViewController.self)), animated: false)
        
        tableView.register(MainCell.self, forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 365
        
        Networking.shared.fetchNoteList(page: 1) { notes in
            self.notes = notes
            self.tableView.reloadData()
        }
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
