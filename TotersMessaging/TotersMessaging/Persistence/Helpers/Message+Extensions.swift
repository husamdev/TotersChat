//
//  Message+Extensions.swift
//  TotersMessaging
//
//  Created by Husam Dayya on 30/01/2022.
//

import Foundation

public extension Message {
    func toLocal() -> LocalMessage {
        LocalMessage(id: id, message: message, date: date, sender: sender.toLocal(), receiver: receiver.toLocal())
    }
}

public extension Array where Element == LocalMessage {
    func toModels() -> [Message] {
        map { $0.toModel() }
    }
}
