//
//  LocalMessage.swift
//  TotersMessaging
//
//  Created by Husam Dayya on 26/01/2022.
//

import Foundation

public struct LocalMessage: Equatable, Codable {
    public let id: UUID
    public let message: String
    public let date: Date
    public let sender: LocalContact
    public let receiver: LocalContact
    
    public init(id: UUID, message: String, date: Date, sender: LocalContact, receiver: LocalContact) {
        self.id = id
        self.message = message
        self.date = date
        self.sender = sender
        self.receiver = receiver
    }
}

extension LocalMessage {
    func toModel() -> Message {
        Message(id: id, message: message, date: date, sender: sender.toModel(), receiver: receiver.toModel())
    }
}
