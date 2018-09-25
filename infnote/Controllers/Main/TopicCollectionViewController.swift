//
//  TopicCollectionViewController.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/10.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class TopicCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, IndicatorInfoProvider {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: ViewConst.horizontalMargin, bottom: 20, right: ViewConst.horizontalMargin)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 20, height: 150)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 20
        layout.headerReferenceSize = CGSize(width: 50, height: 50)
        collectionView.collectionViewLayout = layout
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
        return header
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "话题")
    }
    
}


class TopicCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followedLabel: UILabel!
    func prepareViews() {
        
    }
}
