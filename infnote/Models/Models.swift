//
//  Models.swift
//  infnote
//
//  Created by Vergil Choi on 2018/9/26.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable, CustomStringConvertible {
    static var current: User?
    
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
        dateCreated <- (map["date_created"], DateTransform())
    }
    
    var description: String {
        return "\(id!) - \(nickname!) - \(dateCreated!)"
    }
    
    func save() {
        UserDefaults.standard.set(id, forKey: "infnote.current.user_id")
        User.current = self
        try! key?.save()
    }
    
    class func load() {
        if let userID = UserDefaults.standard.object(forKey: "infnote.current.user_id") as? String {
            Networking.shared.fetchUser(id: userID, complete: { user in
                User.current = user
                User.current?.key = Key.loadDefaultKey()
            }, failed: nil)
        }
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
    var dateConfirmed: Date?
    var isConfirmed: Bool!
    var blockHeight: Int?
    
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id              <- map["id"]
        replies         <- map["replies"]
        lastReply       <- map["last_reply"]
        user            <- map["user"]
        title           <- map["title"]
        content         <- map["content"]
        dateSubmitted   <- map["date_submitted"]
        replyTo         <- map["reply_to"]
        signature       <- map["signature"]
        payloadID       <- map["payload_id"]
        dateConfirmed   <- map["date_confirmed"]
        isConfirmed     <- map["is_confirmed"]
        blockHeight     <- map["block_height"]
    }
    
    var description: String {
        return "\(user!.id!): \(title ?? id!)"
    }
}
