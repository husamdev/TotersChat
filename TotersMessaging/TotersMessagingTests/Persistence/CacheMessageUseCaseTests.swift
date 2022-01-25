//
//  CacheMessageUseCaseTests.swift
//  TotersMessagingTests
//
//  Created by Husam Dayya on 26/01/2022.
//

import XCTest
import TotersMessaging

class LocalMessagesLoader {
    
    init(store: MessageStore) {}
}

class MessageStore {
    
    var insertMessageCallCount = 0
    
}

class CacheMessageUseCaseTests: XCTestCase {

    func test_init_doesNotInsertToStoreUponCreation() {
        let (store, _) = makeSUT()
        
        XCTAssertEqual(store.insertMessageCallCount, 0)
    }
    
    // MARK: - Helpers
    private func makeSUT() -> (store: MessageStore, sut: LocalMessagesLoader) {
        let store = MessageStore()
        let loader = LocalMessagesLoader(store: store)
        
        return (store, loader)
    }
}
