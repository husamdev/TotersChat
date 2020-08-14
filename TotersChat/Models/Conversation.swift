//
//  Conversation.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/14/20.
//

import Foundation

class Conversation {
    let lastMessage: Message?
    let contact: Contact
    
    init(contact: Contact, lastMessage: Message?) {
        self.contact = contact
        self.lastMessage = lastMessage
    }
}
