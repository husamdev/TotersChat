//
//  MessagingTestCase.swift
//  TotersMessagingTests
//
//  Created by Husam Dayya on 24/01/2022.
//

import XCTest

class MessagingService {
    
    init(client: MessagingClientSpy) {}
    
}

class MessagingClientSpy {
    var sendMessageCallCount = 0
}

class MessagingTestCase: XCTestCase {

    func test_init_doesNotSendMessagesOnInit() {
        let (client, _) = makeSUT()
        
        XCTAssertEqual(client.sendMessageCallCount, 0)
    }
    
    // MARK: - Helpers
    private func makeSUT() -> (client: MessagingClientSpy, sut: MessagingService) {
        let client = MessagingClientSpy()
        let sut = MessagingService(client: client)
        
        return (client, sut)
    }
}
