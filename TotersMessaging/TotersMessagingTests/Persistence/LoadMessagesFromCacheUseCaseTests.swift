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
        
        sut.load()
        
        XCTAssertEqual(store.requests, [.retrieve])
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
