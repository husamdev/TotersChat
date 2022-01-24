//
//  MessagingTestCase.swift
//  TotersMessagingTests
//
//  Created by Husam Dayya on 24/01/2022.
//

import XCTest

class MessagingTestCase: XCTestCase {

    func test_init_doesNotSendMessagesOnInit() {
        let client = MessagingClientSpy()
        _ = MessagingService(client: client)
        
        XCTAssertEqual(client.sendMessageCallCount, 0)
    }
    
    // MARK: - Helpers
    private class MessagingClientSpy {
        var sendMessageCallCount = 0
    }
    
    private class MessagingService {
        
        init(client: MessagingClientSpy) { }
    }
}
