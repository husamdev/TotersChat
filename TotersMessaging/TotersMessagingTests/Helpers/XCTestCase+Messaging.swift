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

func anyMessage() -> Message {
    Message(id: UUID(), message: "any message", date: Date(), sender: anyContact(), receiver: anyContact())
}
