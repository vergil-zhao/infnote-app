//
//  FollowingViewController.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/10.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class FollowingViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        settings.style.buttonBarItemFont = UIFont(name: DEFAULT_FONT_DEMI_BOLD, size: 16)!
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.buttonBarItemTitleColor = .black
        settings.style.selectedBarBackgroundColor = MAIN_COLOR
        settings.style.buttonBarHeight = 44
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        
        super.viewDidLoad()
        
        view.bounds.origin = CGPoint(x: 0, y: -ViewConst.safeAreaHeight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return [storyboard!.instantiateViewController(withIdentifier: NSStringFromClass(NoteFlowViewController.self)), storyboard!.instantiateViewController(withIdentifier: NSStringFromClass(NoteFlowViewController.self))]
    }

}
