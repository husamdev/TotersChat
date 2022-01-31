//
//  CodableMessagesStoreTests.swift
//  TotersMessagingTests
//
//  Created by Husam Dayya on 30/01/2022.
//

import XCTest
import TotersMessaging

class CodableMessagesStore {
    func retrieve(contact: LocalContact, completion: @escaping MessageStore.RetrieveCompletion) {
        completion(.success([]))
    }
}

class CodableMessagesStoreTests: XCTestCase {
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = CodableMessagesStore()
        
        let exp = expectation(description: "Wait for completion")
        sut.retrieve(contact: anyContact().toLocal()) { result in
            switch result {
            case .success(let messages):
                XCTAssertTrue(messages.isEmpty)
            default:
                XCTFail("Expected empty cache got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = CodableMessagesStore()
        let contact = anyContact().toLocal()
        
        let exp = expectation(description: "Wait for completion")
        sut.retrieve(contact: contact) { firstResult in
            sut.retrieve(contact: contact) { secondResult in
                switch (firstResult, secondResult) {
                case let (.success(firstMessages), .success(secondMessages)):
                    XCTAssertTrue(firstMessages.isEmpty)
                    XCTAssertTrue(secondMessages.isEmpty)
                    
                default:
                    XCTFail("Expected retrieving empty data twice got first result: \(firstResult) and second result: \(secondResult) instead")
                }
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
}
