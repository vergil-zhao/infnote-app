//
//  Networking.swift
//  infnote
//
//  Created by Vergil Choi on 2018/9/26.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import InfnoteChain


class Networking {
    
    static let shared = Networking()
    
    var host: String {
        get {
            if let addr = UserDefaults.standard.string(forKey: "com.infnote.defaults.server.addr"), addr.count > 0 {
                return addr
            }
            return "https://api.infnote.com"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "com.infnote.defaults.server.addr")
        }
    }
    
    private init() {}
    
    func fetchUser(id: String, complete: ((User) -> Void)?, failed: ((Error) -> Void)? = nil) {
        AF.request(host + "/user/id/\(id)/").validate().responseObject { (response: DataResponse<User>) in
            if let user = response.value {
                complete?(user)
            }
            else {
                failed?(response.error!)
                print(response.data!.utf8!)
            }
        }
    }
    
    func fetchNote(id: String, complete: ((Note) -> Void)?, failed: ((Error) -> Void)? = nil) {
        AF.request(host + "/post/\(id)/").responseObject { (response: DataResponse<Note>) in
            if let note = response.result.value {
                note.cacheMarkdownResult()
                complete?(note)
            }
            else {
                failed?(response.error!)
            }
        }
    }
    
    func fetchNoteList(page: Int = 1, complete: (([Note]) -> Void)?, failed: ((Error) -> Void)? = nil) {
        let safe = UserDefaults.standard.value(forKey: "infnote.user.safe_mode") as? Bool ?? true
        AF.request(host + "/post/list/?page=\(page)&safe=\(safe ? 1 : 0)").responseObject { (response: DataResponse<NoteListResponse>) in
            if let list = response.result.value {
                for note in list.notes {
                    note.cacheMarkdownResult()
                }
                complete?(list.notes)
            }
            else {
                failed?(response.error!)
            }
        }
    }
    
    func fetchNoteList(user: User, page: Int = 1, complete: (([Note]) -> Void)?, failed: ((Error) -> Void)? = nil) {
        let safe = UserDefaults.standard.value(forKey: "infnote.user.safe_mode") as? Bool ?? true
        AF.request(host + "/post/list/?page=\(page)&user=\(user.id!)&safe=\(safe ? 1 : 0)").responseObject { (response: DataResponse<NoteListResponse>) in
            if let list = response.result.value {
                for note in list.notes {
                    note.cacheMarkdownResult()
                }
                complete?(list.notes)
            }
            else {
                failed?(response.error!)
            }
        }
    }
    
    func fetchReplyList(noteID: String, page: Int = 1, complete: (([Note]) -> Void)?, failed: ((Error) -> Void)? = nil) {
        AF.request(host + "/post/\(noteID)/replies/?page=\(page)").responseObject { (response: DataResponse<NoteListResponse>) in
            if let list = response.result.value {
                complete?(list.notes)
            }
            else {
                failed?(response.error!)
            }
        }
    }
    
    func create(user: User, complete: ((User) -> Void)?, failed: ((Error) -> Void)? = nil) {
        AF.request(host + "/user/create/", method: .post, parameters: user.toJSON(), encoding: JSONEncoding.default).validate().responseObject { (response: DataResponse<User>) in
            if let user = response.value {
                user.key = Key.loadDefaultKey()
                complete?(user)
            } else {
                failed?(response.error!)
                print(response.data!.utf8!)
            }
        }
    }
    
    func create(note: [String: Any], complete: ((Note) -> Void)?, failed: ((Error) -> Void)? = nil) {
        AF.request(host + "/post/", method: .post, parameters: note, encoding: JSONEncoding.default).validate().responseObject { (response: DataResponse<Note>) in
            if let note = response.value {
                complete?(note)
            }
            else {
                failed?(response.error!)
                print(response.data!.utf8!)
            }
        }
    }
}


class NoteListResponse: Mappable {
    var count: Int = 0
    var notes: [Note] = []
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        count <- map["count"]
        notes <- map["results"]
    }
}
