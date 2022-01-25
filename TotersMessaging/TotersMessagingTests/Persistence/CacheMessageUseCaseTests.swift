//
//  CacheMessageUseCaseTests.swift
//  TotersMessagingTests
//
//  Created by Husam Dayya on 26/01/2022.
//

import XCTest
import TotersMessaging

class LocalMessagesLoader {
    
    private let store: MessageStore
    
    init(store: MessageStore) {
        self.store = store
    }
    
    func save(_ message: Message) {
        store.insert(message)
    }
        
}

class MessageStore {
    
    var insertMessageCallCount = 0
    
    func insert(_ message: Message) {
        insertMessageCallCount += 1
    }
    
}

class CacheMessageUseCaseTests: XCTestCase {

    func test_init_doesNotInsertToStoreUponCreation() {
        let (store, _) = makeSUT()
        
        XCTAssertEqual(store.insertMessageCallCount, 0)
    }
    
    func test_save_saveTwiceRequestsInsertionTwice() {
        let (store, sut) = makeSUT()
        
        sut.save(anyMessage())
        XCTAssertEqual(store.insertMessageCallCount, 1)
        
        sut.save(anyMessage())
        XCTAssertEqual(store.insertMessageCallCount, 2)
    }
    
    // MARK: - Helpers
    private func makeSUT() -> (store: MessageStore, sut: LocalMessagesLoader) {
        let store = MessageStore()
        let loader = LocalMessagesLoader(store: store)
        
        return (store, loader)
    }
        
    private func anyContact() -> Contact {
        Contact(id: UUID(), firstName: "any firstname", lastName: "any lastname")
    }
    
    private func anyMessage() -> Message {
        Message(id: UUID(), message: "any message", date: Date(), sender: anyContact(), receiver: anyContact())
    }
}
