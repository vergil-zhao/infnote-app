//
//  MeHeaderView.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/2.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit
import SnapKit

class UserHeaderView: UIView {
    
    let backgroundImageView = UIImageView()
    let avatarView          = UIImageView()
    let nicknameLabel       = UILabel()
    let bioLabel            = UILabel()
    let postCountLabel      = UILabel()
    let postLabel           = UILabel()
    let likeCountLabel      = UILabel()
    let likeLabel           = UILabel()
    let editButton          = UIButton()
    let bottomLine          = UIView()
    
    func prepareViews(with user: User) {
        self.frame.size.height = 180 + UIScreen.main.bounds.height * 0.35
        self.frame.size.width = UIScreen.main.bounds.width
        self.backgroundColor = .white
        
        self.addSubview(backgroundImageView)
        self.addSubview(avatarView)
        self.addSubview(nicknameLabel)
        self.addSubview(bioLabel)
        self.addSubview(postCountLabel)
        self.addSubview(postLabel)
        self.addSubview(likeCountLabel)
        self.addSubview(likeLabel)
        self.addSubview(editButton)
        self.addSubview(bottomLine)
        
        backgroundImageView.image = #imageLiteral(resourceName: "launch-background")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.snp.makeConstraints({ make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height * 0.35)
        })
        
        avatarView.image = #imageLiteral(resourceName: "default-avatar")
        avatarView.layer.cornerRadius = 40
        avatarView.layer.masksToBounds = true
        avatarView.snp.makeConstraints { make in
            make.centerY.equalTo(backgroundImageView.snp.bottom)
            make.left.equalToSuperview().offset(ViewConst.horizontalMargin)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        
        nicknameLabel.text = user.nickname
        nicknameLabel.font = UIFont(name: DEFAULT_FONT_DEMI_BOLD, size: 16)
        nicknameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarView.snp.right).offset(10)
            make.top.equalTo(backgroundImageView.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-ViewConst.horizontalMargin)
        }
        
        bioLabel.text = user.bio
        bioLabel.font = UIFont(name: DEFAULT_FONT_REGULAR, size: 14)
        bioLabel.textColor = .darkGray
        bioLabel.numberOfLines = 3
        bioLabel.snp.makeConstraints { make in
            make.left.equalTo(nicknameLabel.snp.left)
            make.top.equalTo(nicknameLabel.snp.bottom).offset(ViewConst.lineSpace)
            make.right.equalToSuperview().offset(-ViewConst.horizontalMargin)
        }
        
        postLabel.text = "发表的文章"
        postLabel.font = UIFont(name: DEFAULT_FONT_REGULAR, size: 14)
        postLabel.textColor = .darkGray
        postLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(ViewConst.horizontalMargin)
            make.bottom.equalToSuperview().offset(-ViewConst.verticalMargin)
        }
        
        postCountLabel.text = "\(user.topics ?? 0)"
        postCountLabel.font = UIFont(name: DEFAULT_FONT_DEMI_BOLD, size: 14)
        postCountLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(ViewConst.horizontalMargin)
            make.bottom.equalTo(postLabel.snp.top)
        }
        
//        likeLabel.text = "收到的赞"
//        likeLabel.font = UIFont(name: DEFAULT_FONT_REGULAR, size: 14)
//        likeLabel.textColor = .darkGray
//        likeLabel.snp.makeConstraints { make in
//            make.left.equalTo(postLabel.snp.right).offset(50)
//            make.bottom.equalToSuperview().offset(-ViewConst.verticalMargin)
//        }
//
//        likeCountLabel.text = "0"
//        likeCountLabel.font = UIFont(name: DEFAULT_FONT_DEMI_BOLD, size: 14)
//        likeCountLabel.snp.makeConstraints { make in
//            make.left.equalTo(postLabel.snp.right).offset(50)
//            make.bottom.equalTo(postLabel.snp.top)
//        }
//
//        editButton.setTitle("编辑", for: .normal)
//        editButton.setTitleColor(.white, for: .normal)
//        editButton.titleLabel?.font = UIFont(name: DEFAULT_FONT_REGULAR, size: 14)
//        editButton.backgroundColor = MAIN_COLOR
//        editButton.layer.cornerRadius = 5
//        editButton.snp.makeConstraints { make in
//            make.right.equalToSuperview().offset(-ViewConst.horizontalMargin)
//            make.bottom.equalToSuperview().offset(-ViewConst.verticalMargin)
//            make.width.equalTo(80)
//            make.height.equalTo(40)
//        }
        
        bottomLine.backgroundColor = UIColor(white: 0.85, alpha: 1)
        bottomLine.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(ViewConst.horizontalMargin)
            make.right.equalToSuperview().offset(-ViewConst.horizontalMargin)
            make.height.equalTo(0.5)
        }
    }

}
