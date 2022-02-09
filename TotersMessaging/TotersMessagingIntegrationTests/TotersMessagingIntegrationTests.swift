//
//  TotersMessagingIntegrationTests.swift
//  TotersMessagingIntegrationTests
//
//  Created by Husam Dayya on 09/02/2022.
//

import XCTest
import Foundation
import TotersMessaging

class TotersMessagingIntegrationTests: XCTestCase {

    func test_load_deliversEmptyCacheOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, with: anyContact(), toCompleteWith: .success([]))
    }
    
    func test_load_deliversItemsSavedOnASeparateInstance() {
        let sutToPerformSave = makeSUT()
        let sutToPerformLoad = makeSUT()
        
        let contact = anyContact()
        let message = anyMessage(to: contact)
        
        let exp = expectation(description: "Wait for completion")
        sutToPerformSave.save(message.model) { insertionError in
            XCTAssertNil(insertionError, "Expected to save message successfully")
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        expect(sutToPerformLoad, with: contact, toCompleteWith: .success([message.model]))
    }
    
    // MARK: - Helpers
    private func expect(_ sut: LocalMessagesLoader, with contact: Contact, toCompleteWith expectedResult: LocalMessagesLoader.LoadResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for completion")
        
        sut.loadMessages(with: contact) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedMessages), .success(expectedMessages)):
                XCTAssertEqual(receivedMessages, expectedMessages, file: file, line: line)
                
            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(receivedError as NSError, expectedError as NSError, file: file, line: line)
                
            default:
                XCTFail("Expected \(expectedResult) got \(receivedResult) instead.")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> LocalMessagesLoader {
        let storeBundle = Bundle(for: CoreDataMessageStore.self)
        let messageStore = try! CoreDataMessageStore(storeURL: testSpecificStoreURL(), bundle: storeBundle)
        let sut = LocalMessagesLoader(store: messageStore)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(messageStore, file: file, line: line)
        
        return sut
    }
    
    private func testSpecificStoreURL() -> URL {
        cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
