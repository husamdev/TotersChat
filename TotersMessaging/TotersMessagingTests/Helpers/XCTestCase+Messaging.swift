//
//  XCTestCase+Messaging.swift
//  TotersMessagingTests
//
//  Created by Husam Dayya on 26/01/2022.
//

import Foundation
import TotersMessaging

func anyContact() -> Contact {
    Contact(id: UUID(), firstName: "any firstname", lastName: "any lastname")
}

func anyMessage() -> (model: Message, local: LocalMessage) {
    let message = Message(id: UUID(), message: "any message", date: Date(), sender: anyContact(), receiver: anyContact())
    return (message, message.toLocal())
}
