//
//  XCTestCase+MessageStoreSpecs.swift
//  TotersMessagingTests
//
//  Created by Husam Dayya on 02/02/2022.
//

import Foundation
import XCTest
import TotersMessaging

extension MessageStoreSpecs where Self: XCTestCase {
    func expect(_ sut: MessageStore, toCompleteWith expectedResult: Result<[LocalMessage], Error>, whenContacting contact: Contact, file: StaticString = #file, line: UInt = #line) {
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
    
    func expect(_ sut: MessageStore, toRetrieveTwice expectedResult: Result<[LocalMessage], Error>, whenContacting contact: Contact, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toCompleteWith: expectedResult, whenContacting: contact, file: file, line: line)
        expect(sut, toCompleteWith: expectedResult, whenContacting: contact, file: file, line: line)
    }
    
    @discardableResult
    func insert(_ sut: MessageStore, _ message: LocalMessage, file: StaticString = #file, line: UInt = #line) -> Error? {
        let exp = expectation(description: "Wait for completion")
        
        var capturedError: Error?
        sut.insert(message) { insertionError in
            capturedError = insertionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        
        return capturedError
    }
}
