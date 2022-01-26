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
        
        sut.load { _ in }
        
        XCTAssertEqual(store.requests, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() {
        let (store, sut) = makeSUT()
        
        let retrievalError = anyNSError()
        let exp = expectation(description: "Wait for completion")
        
        var recievedError: Error?
        sut.load { error in
            recievedError = error
            exp.fulfill()
        }
        
        store.completeRetrieve(with: retrievalError)
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(recievedError as NSError?, retrievalError)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (store: MessageStoreSpy, sut: LocalMessagesLoader) {
        let store = MessageStoreSpy()
        let loader = LocalMessagesLoader(store: store)
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        
        return (store, loader)
    }
}
