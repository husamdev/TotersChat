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
        do {
            let localMessages = try cachedLocalMessages()
            
            completion(.success(localMessages))
        } catch {
            completion(.failure(error))
        }
    }
    
    func insert(_ message: LocalMessage, completion: @escaping MessageStore.InsertionCompletion) {
        do {
            let cachedLocalMessages = try cachedLocalMessages()
            let root = Root(localMessages: cachedLocalMessages + [message])
            let json = try JSONEncoder().encode(root)
            try json.write(to: storeURL)
            
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    private func cachedLocalMessages() throws -> [LocalMessage] {
        guard let data = try? Data(contentsOf: storeURL) else {
            return []
        }
        
        let root = try JSONDecoder().decode(Root.self, from: data)
        return root.localMessages
    }
}

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
    
    func test_retrieveAfterInsertingTwiceToEmptyCache_deliversInstertedValues() {
        let sut = makeSUT()
        let contact = anyContact()
        let message1 = anyMessage(from: contact)
        let message2 = anyMessage(from: contact)

        let exp = expectation(description: "Wait for completion")
        sut.insert(message1.local) { insertionError in

            XCTAssertNil(insertionError, "Expected message to be inserted successfully.")

            sut.insert(message2.local) { secondInsertionError in
                XCTAssertNil(insertionError, "Expected message to be inserted successfully.")

                sut.retrieve(contact: contact.toLocal()) { result in
                    switch (result) {
                    case let .success(retrievedMessages):
                        XCTAssertEqual(retrievedMessages, [message1.local, message2.local])

                    default:
                        XCTFail("Expected retrieving \(message1) and \(message2) got \(result) instead")
                    }
                }
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CodableMessagesStore {
        let sut = CodableMessagesStore(storeURL: makeTestStoreURL())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func makeTestStoreURL() -> URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("\(type(of: self)).store")
    }
    
    private func removeTestArtifacts() {
        do {
            try FileManager.default.removeItem(at: makeTestStoreURL())
            print("Test store file is deleted")
        } catch {
            print(error)
        }
    }
    
    private func setupEmptyStoreState() {
        removeTestArtifacts()
    }
    
    private func undoStoreSideEffects() {
        removeTestArtifacts()
    }
}
