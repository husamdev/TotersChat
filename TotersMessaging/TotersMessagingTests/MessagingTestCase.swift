//
//  MessagingTestCase.swift
//  TotersMessagingTests
//
//  Created by Husam Dayya on 24/01/2022.
//

import XCTest

class MessagingService {
    
    private let client: MessagingClientSpy
    
    init(client: MessagingClientSpy) {
        self.client = client
    }
    
    func send(_ message: String, from: Contact, to: Contact) {
        client.send(Message(id: UUID(), message: message, date: Date(), sender: from, receiver: to))
    }
}

class MessagingClientSpy {
    var sendMessageCallCount = 0
    
    func send(_ message: Message) {
        sendMessageCallCount += 1
    }
}

struct Contact {
    let id: UUID
    let firstName: String
    let lastName: String
}

struct Message {
    let id: UUID
    let message: String
    let date: Date
    let sender: Contact
    let receiver: Contact
}

class MessagingTestCase: XCTestCase {

    func test_init_doesNotSendMessagesOnInit() {
        let (client, _) = makeSUT()
        
        XCTAssertEqual(client.sendMessageCallCount, 0)
    }
    
    func test_sendTwice_sendsMessageTwice() {
        let (client, sut) = makeSUT()
        
        let sender = anyContact()
        let receiver = anyContact()
        
        sut.send("any message", from: sender, to: receiver)
        sut.send("any message 2", from: sender, to: receiver)
        
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
