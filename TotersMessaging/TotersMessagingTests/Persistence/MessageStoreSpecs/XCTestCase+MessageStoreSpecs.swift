//
//  XCTestCase+FailableRetrieveMessageStoreSpecs.swift
//  TotersMessagingTests
//
//  Created by Husam Dayya on 04/02/2022.
//

import Foundation
import XCTest
import TotersMessaging

extension MessageStoreSpecs where Self: XCTestCase {
    func assertRetrieveDeliversEmptyOnEmptyCache(_ sut: MessageStore, file: StaticString = #file, line: UInt = #line) {
        let contact = anyContact()
        
        expect(sut, toCompleteWith: .success([]), whenContacting: contact, file: file, line: line)
    }
    
    func assertRetrieveHasNoSideEffectsOnEmptyCache(_ sut: MessageStore, file: StaticString = #file, line: UInt = #line) {
        let contact = anyContact()
        
        expect(sut, toRetrieveTwice: .success([]), whenContacting: contact, file: file, line: line)
    }
    
    func assertRetrieveDeliversFoundValuesOnNonEmptyCache(_ sut: MessageStore, file: StaticString = #file, line: UInt = #line) {
        let contact = anyContact()
        
        let message1 = anyMessage(from: contact)
        let message2 = anyMessage(from: contact)
        
        insert(sut, message1.local)
        insert(sut, message2.local)
        
        expect(sut, toCompleteWith: .success([message1.local, message2.local]), whenContacting: contact, file: file, line: line)
    }
    
    func assertRetrieveHasNoSideEffectsOnNonEmptyCache(_ sut: MessageStore, file: StaticString = #file, line: UInt = #line) {
        let contact = anyContact()
        
        let message = anyMessage(from: contact)
        
        insert(sut, message.local)
        
        expect(sut, toRetrieveTwice: .success([message.local]), whenContacting: contact, file: file, line: line)
    }
    
    func assertRetrieveDeliversMessagesForSelectedContact(_ sut: MessageStore, file: StaticString = #file, line: UInt = #line) {
        let firstContact = anyContact()
        let firstMessage = anyMessage(from: firstContact)
        
        let secondContact = anyContact()
        let secondMessage = anyMessage(from: secondContact)
        let thirdMessage = anyMessage(to: secondContact)
        
        insert(sut, firstMessage.local)
        insert(sut, secondMessage.local)
        insert(sut, thirdMessage.local)
        
        expect(sut, toCompleteWith: .success([firstMessage.local]), whenContacting: firstContact, file: file, line: line)
        expect(sut, toCompleteWith: .success([secondMessage.local, thirdMessage.local]), whenContacting: secondContact, file: file, line: line)
    }
    
    func assertStoreSideEffectsRunSerially(_ sut: MessageStore, file: StaticString = #file, line: UInt = #line) {
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
        
        XCTAssertEqual(completedOperationsOrder, [op1, op2, op3], file: file, line: line)
    }
}
