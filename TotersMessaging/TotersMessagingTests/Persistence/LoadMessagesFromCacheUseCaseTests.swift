//
//  LoadMessagesFromCacheUseCaseTests.swift
//  TotersMessagingTests
//
//  Created by Husam Dayya on 26/01/2022.
//

import XCTest
import TotersMessaging

class LoadMessagesFromCacheUseCaseTests: XCTestCase {

    func test_init_doesNotRequestStoreUponCreation() {
        let (store, _) = makeSUT()
        
        XCTAssertEqual(store.requests, [])
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (store: MessageStoreSpy, sut: LocalMessagesLoader) {
        let store = MessageStoreSpy()
        let loader = LocalMessagesLoader(store: store)
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        
        return (store, loader)
    }

    class MessageStoreSpy: MessageStore {
        var insertionCompletions = [MessageStore.InsertionCompletion]()
        var requests = [Request]()
        
        enum Request: Equatable {
            case insert(Message)
            case retrieve
        }
        
        func insert(_ message: Message, completion: @escaping MessageStore.InsertionCompletion) {
            requests.append(.insert(message))
            insertionCompletions.append(completion)
        }
        
        func completeInsertion(with error: Error, at index: Int = 0) {
            insertionCompletions[index](error)
        }
        
        func completeInsertionSuccessfully(at index: Int = 0) {
            insertionCompletions[index](nil)
        }
    }
}

extension Message: Equatable {
    public static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id 
    }
}
