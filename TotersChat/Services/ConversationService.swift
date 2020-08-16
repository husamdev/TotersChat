//
//  ConversationService.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/14/20.
//

import Foundation
import RealmSwift
import PromiseKit

/// Service responsible for retreiving list of sorted conversations by date
class ConversationService {
    
    let contactsService = ContactsCreatorService()
    
    /// Returns a list of conversations sorted by the date
    func getConversations() -> Promise<[Conversation]> {
        return Promise<[Conversation]> { seal in
            var conversations: [Conversation] = []
            let contacts = contactsService.getContacts()
            let realm = try! Realm()
            
            for contact in contacts {
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
