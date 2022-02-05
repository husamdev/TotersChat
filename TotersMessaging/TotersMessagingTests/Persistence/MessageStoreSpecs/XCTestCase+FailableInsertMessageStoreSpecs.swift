//
//  XCTestCase+FailableInsertMessageStoreSpecs.swift
//  TotersMessagingTests
//
//  Created by Husam Dayya on 04/02/2022.
//

import Foundation
import XCTest
import TotersMessaging

extension MessageStoreSpecs where Self: XCTestCase {
    func assertInsertDeliversOneMessageWhenInsertingSameMessageTwice(_ sut: MessageStore) {
        let contact = anyContact()
        let message = anyMessage(from: contact)
        
        insert(sut, message.local)
        insert(sut, message.local)
        
        expect(sut, toCompleteWith: .success([message.local]), whenContacting: contact)
    }
    
    func assertInsertDeliversErrorWhenInsertingSameMessageTwice(_ sut: MessageStore) {
        let contact = anyContact()
        let message = anyMessage(from: contact)
        
        insert(sut, message.local)
        
        let secondInsertionError = insert(sut, message.local)
        
        XCTAssertNotNil(secondInsertionError)
    }
    
    func assertInsertDeliversErrorOnInsertionError(_ sut: MessageStore) {
        let message = anyMessage(to: anyContact())
        let insertionError = insert(sut, message.local)
        
        XCTAssertNotNil(insertionError, "Expected cache insertion failure got success instead.")
    }
}
