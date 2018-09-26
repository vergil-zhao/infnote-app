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

let HOST = "http://127.0.0.1:8000"

class Networking {
    
    static let shared = Networking()
    
    private init() {}
    
    func fetchUser(id: String, complete: @escaping (User) -> Void, failed: ((Error) -> Void)?) {
        request(HOST + "/user/id/\(id)/").validate().responseObject { (response: DataResponse<User>) in
            if let user = response.value {
                complete(user)
            }
            else {
                failed?(response.error!)
                print(response.data!.utf8!)
            }
        }
    }
    
    func fetchUser(publicKey: String, complete: @escaping (User) -> Void, failed: ((Error) -> Void)?) {
        request(HOST + "/user/pk/\(publicKey)").validate().responseObject { (response: DataResponse<User>) in
            if let user = response.value {
                complete(user)
            }
            else {
                failed?(response.error!)
                print(response.data!.utf8!)
            }
        }
    }
    
    func fetchNote(id: String) {
        request(HOST + "/post/\(id)/").responseObject { (response: DataResponse<Note>) in
            if let note = response.result.value {
                print(note)
            }
        }
    }
    
    func fetchNoteList(page: Int) {
        request(HOST + "/post/list/").responseObject { (response: DataResponse<NoteListResponse>) in
            if let list = response.result.value {
                print(list.notes)
            }
        }
    }
    
    func fetchReplyList(noteID: String) {
        request(HOST + "/post/\(noteID)/replies/").responseObject { (response: DataResponse<NoteListResponse>) in
            if let list = response.result.value {
                print(list.notes)
            }
        }
    }
    
    func create(user: User, complete: @escaping (User) -> Void, failed: @escaping (Error) -> Void) {
        request(HOST + "/user/create/", method: .post, parameters: user.toJSON(), encoding: JSONEncoding.default).validate().responseObject { (response: DataResponse<User>) in
            if let user = response.value {
                complete(user)
            } else {
                failed(response.error!)
                print(response.data!.utf8!)
            }
        }
    }
    
    func create(note: [String: Any], complete: @escaping (Note) -> Void, failed: ((Error) -> Void)?) {
        request(HOST + "/post/", method: .post, parameters: note, encoding: JSONEncoding.default).validate().responseObject { (response: DataResponse<Note>) in
            if let note = response.value {
                complete(note)
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
