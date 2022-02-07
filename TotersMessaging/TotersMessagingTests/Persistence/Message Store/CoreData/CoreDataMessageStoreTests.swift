//
//  CoreDataMessageStoreTests.swift
//  TotersMessagingTests
//
//  Created by Husam Dayya on 05/02/2022.
//

import XCTest
import TotersMessaging

class CoreDataMessageStoreTests: XCTestCase, MessageStoreSpecs, FailableInsertMessageStoreSpecs {
    
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
    
    func test_storeSideEffects_runSerially() {
        let sut = makeSUT()
        
        assertStoreSideEffectsRunSerially(sut)
    }
    
    func test_insert_deliversErrorOnInsertionError() {}
    
    func test_insert_deliversOneMessageWhenInsertingSameMessageTwice() {
        let sut = makeSUT()
        
        assertInsertDeliversOneMessageWhenInsertingSameMessageTwice(sut)
    }
    
    func test_insert_deliversErrorWhenInsertingSameMessageTwice() {
        
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> MessageStore {
        let storeBundle = Bundle(for: CoreDataMessageStore.self)
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataMessageStore(storeURL: storeURL, bundle: storeBundle)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
