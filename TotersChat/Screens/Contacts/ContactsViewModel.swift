//
//  ContactsViewModel.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/14/20.
//

import Foundation
import PromiseKit

class ContactsViewModel {
    
    let conversationService = ConversationService()
    var conversations: [Conversation] = []
    
    func getConversations() -> Promise<Bool> {
        return firstly { () -> Promise<[Conversation]> in
            return conversationService.getConversations()
        }.then { conversations -> Promise<Bool> in
            self.conversations = conversations
            
            return Promise<Bool> { (seal: Resolver<Bool>) in
                seal.fulfill(true)
            }
        }
    }
}
