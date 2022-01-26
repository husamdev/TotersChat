//
//  MessageStoreSpy.swift
//  TotersMessagingTests
//
//  Created by Husam Dayya on 26/01/2022.
//

import Foundation
import TotersMessaging

class MessageStoreSpy: MessageStore {
    var insertionCompletions = [MessageStore.InsertionCompletion]()
    var retrieveCompletions = [MessageStore.InsertionCompletion]()
    
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
    
    func retrieve(completion: @escaping MessageStore.RetrieveCompletion) {
        requests.append(.retrieve)
        retrieveCompletions.append(completion)
    }
    
    func completeRetrieve(with error: Error, at index: Int = 0) {
        retrieveCompletions[index](error)
    }
}

extension Message: Equatable {
    public static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
    }
}
