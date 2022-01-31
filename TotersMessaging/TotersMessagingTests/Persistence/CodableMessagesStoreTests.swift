//
//  CodableMessagesStoreTests.swift
//  TotersMessagingTests
//
//  Created by Husam Dayya on 30/01/2022.
//

import XCTest
import TotersMessaging

class CodableMessagesStoreTests: XCTestCase {
    
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
    
    // MARK: - Helpers
    private func expect(_ sut: MessageStore, toCompleteWith expectedResult: Result<[LocalMessage], Error>, whenContacting contact: Contact, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for completion")
        
        sut.retrieve(contact: contact.toLocal()) { recievedResult in
            switch (recievedResult, expectedResult) {
            case let (.success(recievedMessages), .success(expectedMessages)):
                XCTAssertEqual(recievedMessages, expectedMessages, file: file, line: line)
                
            case (.failure, .failure):
                break
                
            default:
                XCTFail("Expected \(expectedResult) got \(recievedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func expect(_ sut: MessageStore, toRetrieveTwice expectedResult: Result<[LocalMessage], Error>, whenContacting contact: Contact) {
        expect(sut, toCompleteWith: expectedResult, whenContacting: contact)
        expect(sut, toCompleteWith: expectedResult, whenContacting: contact)
    }
    
    @discardableResult
    private func insert(_ sut: MessageStore, _ message: LocalMessage, file: StaticString = #file, line: UInt = #line) -> Error? {
        let exp = expectation(description: "Wait for completion")
        
        var capturedError: Error?
        sut.insert(message) { insertionError in
            capturedError = insertionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        
        return capturedError
    }
    
    private func makeSUT(storeURL: URL? = nil, file: StaticString = #file, line: UInt = #line) -> MessageStore {
        let sut = CodableMessagesStore(storeURL: storeURL ?? makeTestStoreURL())
        trackForMemoryLeaks(sut, file: file, line: line)
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
