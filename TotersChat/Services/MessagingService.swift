//
//  MessagingService.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/15/20.
//

import Foundation
import RealmSwift
import PromiseKit

/// Service used to send messages
class MessagingService {
    
    static var shared: MessagingService = {
        let service = MessagingService()
        return service
    }()
    
    /// Subject used to notify receiving a new message
    var resendMessageSubject = Subject<ChatMessage>()
    
    private init() {
        
    }
    
    /**
     1. Saves message into realm database
     2. Creates a new message to send later by receiver
     3. Sends created message after 0.5 seconds through resendMessageSubject
     */
    func sendMessage(_ message: ChatMessage) {
        saveMessage(message).then { savedMessage in
            self.createMessage(savedMessage)
        }
        .then { createdMessage in
            self.saveMessage(createdMessage)
        }
        .done { createdMessage in
            after(seconds: 0.5)
            self.resendMessageSubject.notify(with: createdMessage)
        }
    }
    
    /// Saves message into realm database
    func saveMessage( _ message: ChatMessage) -> Promise<ChatMessage> {
        return Promise<ChatMessage> { [message] seal in
            let realm = try! Realm()
            try! realm.write {
                realm.add(message)
            }
            
            seal.fulfill(message)
        }
    }
    
    /// Creates a new message from send message
    func createMessage( _ message: ChatMessage) -> Guarantee<ChatMessage> {
        return Guarantee<ChatMessage> { [message] seal in
            let newMessage = ChatMessage()
            newMessage.text = message.text
            newMessage.senderId = message.receiverId
            newMessage.receiverId = Contact.me.id
            newMessage.isSend = false
            seal(newMessage)
        }
    }
    
}
