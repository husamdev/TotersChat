//
//  CodableMessagesStoreTests.swift
//  TotersMessagingTests
//
//  Created by Husam Dayya on 30/01/2022.
//

import XCTest
import TotersMessaging

class CodableMessagesStore {
    
    private struct Root: Codable {
        private let messages: [CodableMessage]
        
        var localMessages: [LocalMessage] {
            messages.map { $0.localMessage }
        }
        
        init(localMessages: [LocalMessage]) {
            self.messages = localMessages.map { CodableMessage(localMessage: $0) }
        }
    }
    
    private struct CodableMessage: Codable {
        private let id: UUID
        private let message: String
        private let date: Date
        private let sender: CodableContact
        private let receiver: CodableContact
        
        var localMessage: LocalMessage {
            LocalMessage(id: id, message: message, date: date, sender: sender.localContact, receiver: receiver.localContact)
        }
        
        init(localMessage: LocalMessage) {
            self.id = localMessage.id
            self.message = localMessage.message
            self.date = localMessage.date
            self.sender = CodableContact(localContact: localMessage.sender)
            self.receiver = CodableContact(localContact: localMessage.receiver)
        }
    }
    
    private struct CodableContact: Codable {
        private let id: UUID
        private let firstName: String
        private let lastName: String
        
        var localContact: LocalContact {
            LocalContact(id: id, firstName: firstName, lastName: lastName)
        }
        
        init(localContact: LocalContact) {
            self.id = localContact.id
            self.firstName = localContact.firstName
            self.lastName = localContact.lastName
        }
    }
    
    private let storeURL: URL
    
    init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    func retrieve(contact: LocalContact, completion: @escaping MessageStore.RetrieveCompletion) {
        guard let data = try? Data(contentsOf: storeURL) else {
            return completion(.success([]))
        }
        
        do {
            let root = try JSONDecoder().decode(Root.self, from: data)
            
            completion(.success(root.localMessages))
        } catch {
            completion(.failure(error))
        }
    }
    
    func insert(_ message: LocalMessage, completion: @escaping MessageStore.InsertionCompletion) {
        do {
            let root = Root(localMessages: [message])
            let json = try JSONEncoder().encode(root)
            try json.write(to: storeURL)
            
            completion(nil)
        } catch {
            completion(error)
        }
    }
}

class CodableMessagesStoreTests: XCTestCase {
    
    override class func setUp() {
        removeTestArtifacts()
        
        super.setUp()
    }
    
    override class func tearDown() {
        super.tearDown()
        
        removeTestArtifacts()
    }
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        
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
        let sut = makeSUT()
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
    
    func test_retrieveAfterInsertingToEmptyCache_deliversInstertedValues() {
        let sut = makeSUT()
        let contact = anyContact()
        let message = anyMessage(from: contact)
        
        let exp = expectation(description: "Wait for completion")
        sut.insert(message.local) { insertionError in
            
            XCTAssertNil(insertionError, "Expected message to be inserted successfully.")
            
            sut.retrieve(contact: contact.toLocal()) { result in
                switch (result) {
                case let .success(retrievedMessages):
                    XCTAssertEqual(retrievedMessages, [message.local])
                    
                default:
                    XCTFail("Expected retrieving \(message) got \(result) instead")
                }
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CodableMessagesStore {
        let sut = CodableMessagesStore(storeURL: Self.testStoreURL())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private static func testStoreURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("messages.store")
    }
    
    private static func removeTestArtifacts() {
        try? FileManager.default.removeItem(at: testStoreURL())
    }
}
