//
//  CacheMessageUseCaseTests.swift
//  TotersMessagingTests
//
//  Created by Husam Dayya on 26/01/2022.
//

import XCTest
import TotersMessaging
import Foundation

class CacheMessageUseCaseTests: XCTestCase {

    func test_save_requestsCacheInsertion() {
        let (store, sut) = makeSUT()
        
        XCTAssertEqual(store.requests, [])
        
        let firstMessage = anyMessage()
        sut.save(firstMessage.model) { _ in }
        XCTAssertEqual(store.requests, [.insert(firstMessage.local)])
        
        let secondMessage = anyMessage()
        sut.save(secondMessage.model) { _ in }
        XCTAssertEqual(store.requests, [.insert(firstMessage.local), .insert(secondMessage.local)])
    }
    
    func test_save_failsOnInsertionError() {
        let (store, sut) = makeSUT()
        let insertionError = anyNSError()
        
        expect(sut, toCompleteWith: insertionError, when: {
            store.completeInsertion(with: insertionError)
        })
    }
    
    func test_save_succeedsOnSuccessfulCacheInsertion() {
        let (store, sut) = makeSUT()
        
        expect(sut, toCompleteWith: nil, when: {
            store.completeInsertionSuccessfully()
        })
    }
    
    func test_save_doesNotDeliverInsertionErrorAfterSUTHasBeenDeallocated() {
        let store = MessageStoreSpy()
        var sut: LocalMessagesLoader? = LocalMessagesLoader(store: store)
        
        var receivedMessages = [LocalMessagesLoader.SaveResult]()
        sut?.save(anyMessage().model) { receivedMessages.append($0) }
        
        sut = nil
        store.completeInsertion(with: anyNSError())
        
        XCTAssertTrue(receivedMessages.isEmpty)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (store: MessageStoreSpy, sut: LocalMessagesLoader) {
        let store = MessageStoreSpy()
        let loader = LocalMessagesLoader(store: store)
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        
        return (store, loader)
    }
    
    private func expect(_ sut: LocalMessagesLoader, toCompleteWith expectedError: NSError?, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for completion")
        
        var recievedError: Error?
        sut.save(anyMessage().model) {
            recievedError = $0
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(expectedError, recievedError as NSError?, file: file, line: line)
    }
}
