//
//  Message.swift
//  TotersMessaging
//
//  Created by Husam Dayya on 26/01/2022.
//

import Foundation

public struct Message: Equatable {
    public let id: UUID
    public let message: String
    public let date: Date
    public let sender: Contact
    public let receiver: Contact
    
    public init(id: UUID, message: String, date: Date, sender: Contact, receiver: Contact) {
        self.id = id
        self.message = message
        self.date = date
        self.sender = sender
        self.receiver = receiver
    }
}
