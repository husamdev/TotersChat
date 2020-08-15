//
//  ConversationService.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/14/20.
//

import Foundation
import RealmSwift
import PromiseKit

class ConversationService {
    
    let contactsService = ContactsCreatorService()
    let count = 20
    
    func getConversations(page: Int) -> Promise<[Conversation]> {
        return Promise<[Conversation]> { seal in
            var conversations: [Conversation] = []
            let contacts = contactsService.getContacts()
            let realm = try! Realm()
            
            let start = page * 20
            let end = start + count - 1
            
            for index in start...end {
                let contact = contacts[index]
                let lastMessage = realm.objects(ChatMessage.self)
                    .filter("senderId == %@ OR receiverId == %@", contact.id, contact.id)
                    .sorted(byKeyPath: "date").last
                
                let conversation = Conversation(contact: contact, lastMessage: lastMessage)
                conversations.append(conversation)
            }
            
            conversations = conversations.sorted { (one, two) -> Bool in
                let t1 = one.lastMessage?.date ?? Date.distantPast
                let t2 = two.lastMessage?.date ?? Date.distantPast
                return t1 > t2
            }
            
            seal.fulfill(conversations)
        }
    }
}
