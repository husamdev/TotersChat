//
//  LoadMessagesFromCacheUseCaseTests.swift
//  TotersMessagingTests
//
//  Created by Husam Dayya on 26/01/2022.
//

import XCTest
import TotersMessaging

class LoadMessagesFromCacheUseCaseTests: XCTestCase {

    func test_init_doesNotRequestStoreUponCreation() {
        let (store, _) = makeSUT()
        
        XCTAssertEqual(store.requests, [])
    }
    
    func test_load_requestsCacheRetrieval() {
        let (store, sut) = makeSUT()
        
        sut.loadMessages(with: anyContact()) { _ in }
        
        XCTAssertEqual(store.requests, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() {
        let (store, sut) = makeSUT()
        let retrievalError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(retrievalError), when: {
            store.completeRetrieval(with: retrievalError)
        })
    }
    
    func test_load_deliversNoMessagesOnEmptyCache() {
        let (store, sut) = makeSUT()
        
        expect(sut, toCompleteWith: .success([]), when: {
            store.completeRetrievalWithEmptyCache()
        })
    }
    
    func test_load_deliversMessagesOnNonEmptyCacheWithSelectedContact() {
        let (store, sut) = makeSUT()
        let cachedMessages = anyMessages()
        
        expect(sut, toCompleteWith: .success(cachedMessages.models), when: {
            store.completeRetrieval(with: cachedMessages.local)
        })
    }
    
    func test_load_doesNotDeliverResultAfterSUTHasBeenDeallocated() {
        let store = MessageStoreSpy()
        var sut: LocalMessagesLoader? = LocalMessagesLoader(store: store)
        
        var recievedResult = [LocalMessagesLoader.LoadResult]()
        sut?.loadMessages(with: anyContact()) { recievedResult.append($0) }
        
        sut = nil
        store.completeRetrieval(with: anyNSError())
        
        XCTAssertTrue(recievedResult.isEmpty)
    }
    
    // MARK: - Helpers
    private func expect(_ sut: LocalMessagesLoader, toCompleteWith expectedResult: LocalMessagesLoader.LoadResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for completion")
        
        sut.loadMessages(with: anyContact()) { recievedResult in
            switch(expectedResult, recievedResult) {
            case let (.success(expectedMessages), .success(recievedMessages)):
                XCTAssertEqual(expectedMessages, recievedMessages, file: file, line: line)
                
            case let (.failure(expectedError), .failure(recievedError)):
                XCTAssertEqual(expectedError as NSError, recievedError as NSError, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult) got \(recievedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (store: MessageStoreSpy, sut: LocalMessagesLoader) {
        let store = MessageStoreSpy()
        let loader = LocalMessagesLoader(store: store)
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        
        return (store, loader)
    }
    
    private func anyMessages() -> (models: [Message], local: [LocalMessage]) {
        let contact1 = anyContact()
        let message1 = anyMessage(to: contact1)
        let message2 = anyMessage(from: contact1)
        
        return (models: [message1.model, message2.model],
                local: [message1.local, message2.local])
    }
}
