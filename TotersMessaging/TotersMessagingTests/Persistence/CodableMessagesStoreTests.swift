//
//  CodableMessagesStoreTests.swift
//  TotersMessagingTests
//
//  Created by Husam Dayya on 30/01/2022.
//

import XCTest
import TotersMessaging

class CodableMessagesStoreTests: XCTestCase, MessageStoreSpecs {
    
    override func setUp() {
        super.setUp()
        
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        
        assertRetrieveDeliversEmptyOnEmptyCache(sut)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        assertRetrieveHasNoSideEffectsOnEmptyCache(sut)
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
        let sut = makeSUT()
        
        assertRetrieveDeliversFoundValuesOnNonEmptyCache(sut)
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        
        assertRetrieveHasNoSideEffectsOnNonEmptyCache(sut)
    }
    
    func test_retrieve_deliversMessagesForSelectedContact() {
        let sut = makeSUT()
        
        assertRetrieveDeliversMessagesForSelectedContact(sut)
    }
    
    func test_retrieve_deliversFailureOnRetrieveError() {
        let storeURL = makeTestStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        expect(sut, toCompleteWith: .failure(anyNSError()), whenContacting: anyContact())
    }
    
    func test_retrieve_hasNoSideEffectsOnFailure() {
        let storeURL = makeTestStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        expect(sut, toRetrieveTwice: .failure(anyNSError()), whenContacting: anyContact())
    }
    
    func test_insert_deliversErrorOnInsertionError() {
        let invalidStoreURL = URL(string: "invalid:///store-url")!
        let sut = makeSUT(storeURL: invalidStoreURL)
        
        assertInsertDeliversErrorOnInsertionError(sut)
    }
    
    func test_insert_deliversOneMessageWhenInsertingSameMessageTwice() {
        let sut = makeSUT()
        
        assertInsertDeliversOneMessageWhenInsertingSameMessageTwice(sut)
    }
    
    func test_insert_deliversErrorWhenInsertingSameMessageTwice() {
        let sut = makeSUT()
        
        assertInsertDeliversErrorWhenInsertingSameMessageTwice(sut)
    }
    
    func test_storeSideEffects_runSerially() {
        let sut = makeSUT()
        
        assertStoreSideEffectsRunSerially(sut)
    }
    
    // MARK: - Helpers
    private func makeSUT(storeURL: URL? = nil, file: StaticString = #file, line: UInt = #line) -> MessageStore {
        let store = CodableMessagesStore(storeURL: storeURL ?? makeTestStoreURL())
        let sut = BackgroundQueueMessagesStore(decoratee: store)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return sut
    }
    
    private func makeTestStoreURL() -> URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("\(type(of: self)).store")
    }
    
    private func removeTestArtifacts() {
        try? FileManager.default.removeItem(at: makeTestStoreURL())
    }
    
    private func setupEmptyStoreState() {
        removeTestArtifacts()
    }
    
    private func undoStoreSideEffects() {
        removeTestArtifacts()
    }
}
