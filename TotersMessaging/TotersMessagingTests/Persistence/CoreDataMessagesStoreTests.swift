//
//  CoreDataMessagesStoreTests.swift
//  TotersMessagingTests
//
//  Created by Husam Dayya on 30/01/2022.
//

import XCTest
import TotersMessaging

class CoreDataMessagesStore {
    func retrieve(contact: LocalContact, completion: @escaping MessageStore.RetrieveCompletion) {
        completion(.success([]))
    }
}

class CoreDataMessagesStoreTests: XCTestCase {

    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = CoreDataMessagesStore()
        
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

}
