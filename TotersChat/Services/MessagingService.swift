//
//  MessagingService.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/15/20.
//

import Foundation
import RealmSwift
import PromiseKit

class MessagingService {
    
    static var shared: MessagingService = {
        let service = MessagingService()
        return service
    }()
    
    var resendMessageSubject = Subject<ChatMessage>()
    
    private init() {
        
    }
    
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
    
    func saveMessage( _ message: ChatMessage) -> Promise<ChatMessage> {
        return Promise<ChatMessage> { [message] seal in
            let realm = try! Realm()
            try! realm.write {
                realm.add(message)
            }
            
            seal.fulfill(message)
        }
    }
    
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
