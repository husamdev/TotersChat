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
        let contact = anyContact()
        
        expect(sut, toCompleteWith: .success([]), whenContacting: contact)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        let contact = anyContact()
        
        expect(sut, toRetrieveTwice: .success([]), whenContacting: contact)
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
        let sut = makeSUT()
        let contact = anyContact()
        
        let message1 = anyMessage(from: contact)
        let message2 = anyMessage(from: contact)
        
        insert(sut, message1.local)
        insert(sut, message2.local)
        
        expect(sut, toCompleteWith: .success([message1.local, message2.local]), whenContacting: contact)
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        let contact = anyContact()
        
        let message = anyMessage(from: contact)
        
        insert(sut, message.local)
        
        expect(sut, toRetrieveTwice: .success([message.local]), whenContacting: contact)
    }
    
    func test_retrieve_deliversMessagesForSelectedContact() {
        let sut = makeSUT()
        
        let firstContact = anyContact()
        let firstMessage = anyMessage(from: firstContact)
        
        let secondContact = anyContact()
        let secondMessage = anyMessage(from: secondContact)
        let thirdMessage = anyMessage(to: secondContact)

        insert(sut, firstMessage.local)
        insert(sut, secondMessage.local)
        insert(sut, thirdMessage.local)
        
        expect(sut, toCompleteWith: .success([firstMessage.local]), whenContacting: firstContact)
        expect(sut, toCompleteWith: .success([secondMessage.local, thirdMessage.local]), whenContacting: secondContact)
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
        
        let message = anyMessage(to: anyContact())
        let insertionError = insert(sut, message.local)
        
        XCTAssertNotNil(insertionError, "Expected cache insertion failure got success instead.")
    }
    
    func test_insert_deliversOneMessageWhenInsertingSameMessageTwice() {
        let sut = makeSUT()
        let contact = anyContact()
        let message = anyMessage(from: contact)
        
        insert(sut, message.local)
        insert(sut, message.local)
        
        expect(sut, toCompleteWith: .success([message.local]), whenContacting: contact)
    }
    
    func test_insert_deliversErrorWhenInsertingSameMessageTwice() {
        let sut = makeSUT()
        let contact = anyContact()
        let message = anyMessage(from: contact)
        
        insert(sut, message.local)
        
        let secondInsertionError = insert(sut, message.local)
        
        XCTAssertNotNil(secondInsertionError)
    }
    
    func test_storeSideEffects_runSerially() {
        let sut = makeSUT()
        
        var completedOperationsOrder = [XCTestExpectation]()
        
        let op1 = expectation(description: "Operation 1")
        let message1 = anyMessage(to: anyContact())
        sut.insert(message1.local) { _ in
            completedOperationsOrder.append(op1)
            op1.fulfill()
        }
        
        let op2 = expectation(description: "Operation 2")
        sut.retrieve(contact: anyContact().toLocal()) { _ in
            completedOperationsOrder.append(op2)
            op2.fulfill()
        }
        
        let op3 = expectation(description: "Operation 3")
        let message3 = anyMessage(to: anyContact())
        sut.insert(message3.local) { _ in
            completedOperationsOrder.append(op3)
            op3.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
        
        XCTAssertEqual(completedOperationsOrder, [op1, op2, op3])
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
