//
//  ChatService.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/16/20.
//

import Foundation
import PromiseKit
import RealmSwift

class ChatService {
    
    func getChat(with contact: Contact) -> Promise<Results<ChatMessage>> {
        return Promise { seal in
            let realm = try! Realm()
            let messages = realm
                .objects(ChatMessage.self)
                .filter("senderId == %@ OR receiverId == %@", contact.id, contact.id)
                .sorted(byKeyPath: "date", ascending: false)
            
            seal.fulfill(messages)
        }
    }
}
