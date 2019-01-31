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
    
    static var current: User? {
        didSet {
            observers.forEach { observer in
                observer.onNext(current)
            }
            if current == nil {
                UserDefaults.standard.set(nil, forKey: "infnote.current.user_id")
                Key.clean()
            }
            else {
                if current?.key == nil {
                    current?.key = Key.loadDefaultKey()
                }
                UserDefaults.standard.set(current!.id, forKey: "infnote.current.user_id")
            }
        }
    }
    
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
    
    var date: Date {
        if blockTime != nil && blockTime!.timeIntervalSince1970 > 1 {
            return blockTime!
        }
        return dateSubmitted
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
    }
    
    var description: String {
        return toJSON().flatten()
    }
}
