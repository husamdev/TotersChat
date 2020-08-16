//
//  ChatViewModel.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/16/20.
//

import Foundation
import PromiseKit
import RealmSwift

class ChatViewModel {
    
    let chatService = ChatService()
    var messages: [ChatMessage] = []
    
    func getChatMessages(contact: Contact) -> Promise<Bool> {
        return firstly { () -> Promise<Results<ChatMessage>> in
            return chatService.getChat(with: contact)
        }.then { messages -> Promise<Bool> in
            self.messages = Array(messages)
            
            return Promise<Bool> { (seal: Resolver<Bool>) in
                seal.fulfill(true)
            }
        }
    }
}
