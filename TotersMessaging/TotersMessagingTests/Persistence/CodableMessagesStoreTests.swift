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
            let allLocalMessages = try cachedLocalMessages()
            
            let localMessagesWithContact = allLocalMessages.filter { message in
                message.isWithContact(contact)
            }
            
            completion(.success(localMessagesWithContact))
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

extension LocalMessage {
    func isWithContact(_ contact: LocalContact) -> Bool {
        receiver == contact || sender == contact
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
        let contact = anyContact()
        
        expect(sut, toCompleteWith: .success([]), whenContacting: contact)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        let contact = anyContact()
        
        expect(sut, toCompleteWith: .success([]), whenContacting: contact)
        expect(sut, toCompleteWith: .success([]), whenContacting: contact)
    }
    
    func test_retrieveAfterInsertingToEmptyCache_deliversInstertedValues() {
        let sut = makeSUT()
        let contact = anyContact()
        let message = anyMessage(from: contact)

        let exp = expectation(description: "Wait for completion")
        sut.insert(message.local) { insertionError in

            XCTAssertNil(insertionError, "Expected message to be inserted successfully.")

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
        
        expect(sut, toCompleteWith: .success([message.local]), whenContacting: contact)
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
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
        
        expect(sut, toCompleteWith: .success([message1.local, message2.local]), whenContacting: contact)
    }
    
    func test_retrieveAfterInserting_deliversMessagesForSelectedContact() {
        let sut = makeSUT()
        let contact1 = anyContact()
        let message1 = anyMessage(from: contact1)
        
        let contact2 = anyContact()
        let message2 = anyMessage(from: contact2)

        let exp = expectation(description: "Wait for completion")
        sut.insert(message1.local) { insertionError in

            XCTAssertNil(insertionError, "Expected message to be inserted successfully.")

            sut.insert(message2.local) { secondInsertionError in
                XCTAssertNil(insertionError, "Expected message to be inserted successfully.")
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
        
        expect(sut, toCompleteWith: .success([message1.local]), whenContacting: contact1)
        expect(sut, toCompleteWith: .success([message2.local]), whenContacting: contact2)
    }
    
    // MARK: - Helpers
    private func expect(_ sut: CodableMessagesStore, toCompleteWith expectedResult: Result<[LocalMessage], Error>, whenContacting contact: Contact) {
        let exp = expectation(description: "Wait for completion")
        
        sut.retrieve(contact: contact.toLocal()) { recievedResult in
            switch (recievedResult, expectedResult) {
            case let (.success(recievedMessages), .success(expectedMessages)):
                
                XCTAssertEqual(recievedMessages, expectedMessages)
                
            default:
                XCTFail("Expected \(expectedResult) got \(recievedResult) instead")
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
