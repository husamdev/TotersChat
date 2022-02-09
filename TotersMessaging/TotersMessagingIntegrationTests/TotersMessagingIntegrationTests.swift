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
        
        let exp = expectation(description: "Wait for completion")
        sut.loadMessages(with: anyContact()) { result in
            switch result {
            case let .success(messages):
                XCTAssertEqual(messages, [], "Expected empty cache")
            case let .failure(error):
                XCTFail("Expected empty cache got \(error) instead.")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
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
