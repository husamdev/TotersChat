//
//  XCTestCase+Messaging.swift
//  TotersMessagingTests
//
//  Created by Husam Dayya on 26/01/2022.
//

import Foundation
import TotersMessaging

func anyContact() -> Contact {
    Contact(id: UUID(),
            firstName: "any firstname",
            lastName: "any lastname")
}

func currentUser() -> Contact {
    Contact(
        id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!,
        firstName: "current user first name",
        lastName: "current user last name")
}

func anyMessage(from: Contact) -> (model: Message, local: LocalMessage) {
    let message = Message(
        id: UUID(),
        message: "any message",
        date: Date(),
        sender: from,
        receiver: currentUser())
    
    return (message, message.toLocal())
}

func anyMessage(to: Contact) -> (model: Message, local: LocalMessage) {
    let message = Message(
        id: UUID(),
        message: "any message",
        date: Date(),
        sender: currentUser(),
        receiver: to)
    
    return (message, message.toLocal())
}
