//
//  MessagingTestCase.swift
//  TotersMessagingTests
//
//  Created by Husam Dayya on 24/01/2022.
//

import XCTest

class MessagingTestCase: XCTestCase {

    func test_init_doesNotSendMessagesOnInit() {
        let (client, _) = makeSUT()
        
        XCTAssertEqual(client.sendMessageCallCount, 0)
    }
    
    // MARK: - Helpers
    private func makeSUT() -> (client: MessagingClientSpy, service: MessagingService) {
        let client = MessagingClientSpy()
        let service = MessagingService(client: client)
        
        return (client, service)
    }
    
    private class MessagingClientSpy {
        var sendMessageCallCount = 0
    }
    
    private class MessagingService {
        
        init(client: MessagingClientSpy) { }
    }
}
