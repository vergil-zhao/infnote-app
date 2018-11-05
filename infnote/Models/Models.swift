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

class Model {
    static let DateToInt = TransformOf<Date, Int>(
        fromJSON: { $0 == nil ? nil : Date(timeIntervalSince1970: TimeInterval($0!)) },
        toJSON: { $0 == nil ? nil : Int($0!.timeIntervalSince1970) })
}

class User: Mappable, CustomStringConvertible {
    static var current: User? {
        didSet {
            if current == nil {
                UserDefaults.standard.set(nil, forKey: "infnote.current.user_id")
            }
        }
    }
    
    var id: String!
    var nickname: String!
    var email: String?
    var avatar: String?
    var gender: Int?
    var bio: String?
    var publicKey: String?
    var signature: String?
    var topics: Int?
    var replies: Int?
    var dateCreated: Date?
    
    var key: Key?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id          <- map["id"]
        nickname    <- map["nickname"]
        email       <- map["email"]
        avatar      <- map["avatar"]
        gender      <- map["gender"]
        bio         <- map["bio"]
        publicKey   <- map["public_key"]
        signature   <- map["signature"]
        topics      <- map["topics"]
        replies     <- map["replies"]
        dateCreated <- (map["date_created"], Model.DateToInt)
    }
    
    var description: String {
        return toJSON().flatten()
    }
    
    func save() {
        UserDefaults.standard.set(id, forKey: "infnote.current.user_id")
        User.current = self
        try! key?.save()
    }
    
    class func load() -> Bool {
        if let userID = UserDefaults.standard.object(forKey: "infnote.current.user_id") as? String {
            Networking.shared.fetchUser(id: userID, complete: { user in
                User.current = user
                User.current?.key = Key.loadDefaultKey()
            }, failed: { error in
                Key.clean()
            })
            return true
        }
        else if let key = Key.loadDefaultKey() {
            Networking.shared.fetchUser(publicKey: key.compressedPublicKey.base58, complete: { user in
                User.current = user
                User.current?.key = key
                user.save()
            }, failed: { error in
                Key.clean()
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
    var dateSubmitted: Date!
    var replyTo: String?
    var signature: String?
    var payloadID: String!
    var blockTime: Date?
    var blockHeight: Int?
    
    var date: Date {
        return blockTime ?? dateSubmitted
    }
    
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id              <- map["id"]
        replies         <- map["replies"]
        lastReply       <- map["last_reply"]
        user            <- map["user"]
        title           <- map["title"]
        content         <- map["content"]
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
