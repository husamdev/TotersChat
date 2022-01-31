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
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
        let sut = makeSUT()
        let contact = anyContact()
        
        let message1 = anyMessage(from: contact)
        let message2 = anyMessage(from: contact)
        
        insert(sut, message1.local)
        insert(sut, message2.local)
        
        expect(sut, toCompleteWith: .success([message1.local, message2.local]), whenContacting: contact)
    }
    
    func test_retrieve_deliversMessagesForSelectedContact() {
        let sut = makeSUT()
        
        let firstContact = anyContact()
        let firstMessage = anyMessage(from: firstContact)
        
        let secondContact = anyContact()
        let secondMessage = anyMessage(from: secondContact)
        let thirdMessage = anyMessage(to: secondContact)

        insert(sut, firstMessage.local)
        insert(sut, secondMessage.local)
        insert(sut, thirdMessage.local)
        
        expect(sut, toCompleteWith: .success([firstMessage.local]), whenContacting: firstContact)
        expect(sut, toCompleteWith: .success([secondMessage.local, thirdMessage.local]), whenContacting: secondContact)
    }
    
    func test_retrieve_deliversFailureOnRetrieveError() {
        let sut = makeSUT()
        
        try! "invalid data".write(to: makeTestStoreURL(), atomically: false, encoding: .utf8)
        
        expect(sut, toCompleteWith: .failure(anyNSError()), whenContacting: anyContact())
    }
    
    // MARK: - Helpers
    private func expect(_ sut: CodableMessagesStore, toCompleteWith expectedResult: Result<[LocalMessage], Error>, whenContacting contact: Contact, file: StaticString = #file, line: UInt = #line) {
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
    
    private func insert(_ sut: CodableMessagesStore, _ message: LocalMessage, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for completion")
        sut.insert(message) { insertionError in
            XCTAssertNil(insertionError, "Expected message to be inserted successfully.", file: file, line: line)
            
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
        try? FileManager.default.removeItem(at: makeTestStoreURL())
    }
    
    private func setupEmptyStoreState() {
        removeTestArtifacts()
    }
    
    private func undoStoreSideEffects() {
        removeTestArtifacts()
    }
}
