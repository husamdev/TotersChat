//
//  MessagingTestCase.swift
//  TotersMessagingTests
//
//  Created by Husam Dayya on 24/01/2022.
//

import XCTest
import TotersMessaging

class MessagingService {
    
    private let client: MessagingClientSpy
    
    init(client: MessagingClientSpy) {
        self.client = client
    }
    
    func send(_ message: String, to: Contact) {
        client.send(Message(id: UUID(), message: message, date: Date(), sender: myself, receiver: to))
    }
}

class MessagingClientSpy {
    var sendMessageCallCount = 0
    
    var onMessageRecieved: ((Message) -> Void)?
    
    func send(_ message: Message) {
        sendMessageCallCount += 1
    }
}

let myself = Contact(id: UUID(),
                     firstName: "Husam",
                     lastName: "Dayya")

class MessagingTestCase: XCTestCase {

    func test_send_sendsMessageToClient() {
        let (client, sut) = makeSUT()
        
        XCTAssertEqual(client.sendMessageCallCount, 0)
        
        sut.send("any message", to: anyContact())
        XCTAssertEqual(client.sendMessageCallCount, 1)
        
        sut.send("any message", to: anyContact())
        XCTAssertEqual(client.sendMessageCallCount, 2)
    }
    
    // MARK: - Helpers
    private func makeSUT() -> (client: MessagingClientSpy, sut: MessagingService) {
        let client = MessagingClientSpy()
        let sut = MessagingService(client: client)
        
        return (client, sut)
    }
    
    private func anyContact() -> Contact {
        Contact(id: UUID(), firstName: "any firstname", lastName: "any lastname")
    }
    
    private func anyMessage(from: Contact, to: Contact) -> Message {
        Message(id: UUID(), message: "any message", date: Date(), sender: from, receiver: to)
    }
}
