//
//  Models.swift
//  infnote
//
//  Created by Vergil Choi on 2018/9/26.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import Foundation
import ObjectMapper
import InfnoteChain
import RxSwift
import Down

let ANONYMOUS_ID = "1HwMRa7tyK5ikhK7YyX76mVCZb6NEYC7Ld"
let ANONYMOUS_KEY = "Ky5DFuCVeiZ62gMcMMhedyHAo7VQDomX7JgMRp8xJ1HdtwqJJoq9"

class Model {
    static let DateToInt = TransformOf<Date, Int>(
        fromJSON: { $0 == nil ? nil : Date(timeIntervalSince1970: TimeInterval($0!)) },
        toJSON: { $0 == nil ? nil : Int($0!.timeIntervalSince1970) })
}

class User: Mappable, CustomStringConvertible {
    
    static private var observers: [AnyObserver<User?>] = []
    
    static var status = Observable<User?>.create { observer in
        let index = observers.count
        observers.append(observer)
        observer.onNext(current)
        return Disposables.create {
            observers.remove(at: index)
        }
    }
    
    static var _current: User?
    static var current: User? {
        get {
            if _current == nil {
                let user = User(JSON: [
                    "user_id": ANONYMOUS_ID,
                    "nickname": __("anonymous"),
                    "email": __("anonymous@infnote.com"),
                ])
                user?.isAnonymous = true
                user?.key = Key(wif: ANONYMOUS_KEY)
                return user
            }
            return _current
        }
        set {
            _current = newValue
            observers.forEach { observer in
                observer.onNext(newValue)
            }
            if newValue == nil {
                UserDefaults.standard.set(nil, forKey: "infnote.current.user_id")
                Key.clean()
            }
            else {
                if newValue?.key == nil {
                    newValue?.key = Key.loadDefaultKey()
                }
                UserDefaults.standard.set(newValue!.id, forKey: "infnote.current.user_id")
            }
        }
    }
    
    var isAnonymous = false
    
    var id: String!
    var nickname: String!
    var email: String?
    var avatar: String?
    var gender: Int?
    var bio: String?
    var signature: String?
    var topics: Int?
    var replies: Int?
    var dateCreated: Date?
    
    var key: Key?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id          <- map["user_id"]
        nickname    <- map["nickname"]
        email       <- map["email"]
        avatar      <- map["avatar"]
        gender      <- map["gender"]
        bio         <- map["bio"]
        signature   <- map["signature"]
        topics      <- map["topics"]
        replies     <- map["replies"]
        dateCreated <- (map["date_created"], Model.DateToInt)
    }
    
    var description: String {
        return toJSON().flatten()
    }
    
    class func load() -> Bool {
        if let userID = UserDefaults.standard.object(forKey: "infnote.current.user_id") as? String {
            Networking.shared.fetchUser(id: userID, complete: { user in
                User.current = user
            }, failed: { error in
                User.current = nil
            })
            return true
        }
        return false
    }
}


class Note: Mappable, CustomStringConvertible {
    var id: String!
    var replies: Int!
    var lastReply: String?
    var user: User!
    var title: String?
    var content: String!
    var nsfw: Bool! = true
    var dateSubmitted: Date!
    var replyTo: String?
    var signature: String?
    var blockTime: Date?
    var blockHeight: Int?
    var truncated: Bool?
    
    var attrubutedContent: NSAttributedString!
    
    var date: Date {
        if blockTime != nil && blockTime!.timeIntervalSince1970 > 1 {
            return blockTime!
        }
        return dateSubmitted
    }
    
    func cacheMarkdownResult() {
        let maxWidth = Int(UIScreen.main.bounds.width - ViewConst.horizontalMargin * 2)
        var more = ""
        if truncated == true {
            more = "..."
        }
        attrubutedContent = try! Down(markdownString: content + more)
            .toAttributedString(stylesheet:"""
                body { font-size: 125%; font-family: 'Avenir Next', Helvetica; }
                code, pre { font-family: Menlo }
                img { max-width: \(maxWidth)px }
                """
        )
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id              <- map["id"]
        replies         <- map["replies"]
        lastReply       <- map["last_reply"]
        user            <- map["user"]
        title           <- map["title"]
        content         <- map["content"]
        nsfw            <- map["nsfw"]
        replyTo         <- map["reply_to"]
        signature       <- map["signature"]
        blockHeight     <- map["block_height"]
        dateSubmitted   <- (map["date_submitted"], Model.DateToInt)
        blockTime       <- (map["block_time"], Model.DateToInt)
        truncated       <- map["truncated"]
    }
    
    var description: String {
        return toJSON().flatten()
    }
}
