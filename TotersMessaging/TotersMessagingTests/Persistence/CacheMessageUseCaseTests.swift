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
    
    typealias SaveResult = Error?
    
    init(store: MessageStore) {
        self.store = store
    }
    
    func save(_ message: Message, completion: @escaping (SaveResult) -> Void) {
        store.insert(message, completion: completion)
    }
    
}

class MessageStore {
    typealias InsertionCompletion = (Error?) -> Void
    
    var insertMessageCallCount = 0
    var insertionCompletions = [InsertionCompletion]()
    
    func insert(_ message: Message, completion: @escaping InsertionCompletion) {
        insertMessageCallCount += 1
        insertionCompletions.append(completion)
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](error)
    }
}

class CacheMessageUseCaseTests: XCTestCase {

    func test_save_requestsCacheInsertion() {
        let (store, sut) = makeSUT()
        
        XCTAssertEqual(store.insertMessageCallCount, 0)
        
        sut.save(anyMessage()) { _ in }
        XCTAssertEqual(store.insertMessageCallCount, 1)
        
        sut.save(anyMessage()) { _ in }
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
