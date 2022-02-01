//
//  BackgroundQueueMessagesStore.swift
//  TotersMessaging
//
//  Created by Husam Dayya on 01/02/2022.
//

import Foundation

public class BackgroundQueueMessagesStore: MessageStore {
    
    private let queue = DispatchQueue(label: String(describing: BackgroundQueueMessagesStore.self), qos: .userInitiated, attributes: .concurrent)
    
    private let decoratee: MessageStore
    
    public init(decoratee: MessageStore) {
        self.decoratee = decoratee
    }
    
    public func insert(_ message: LocalMessage, completion: @escaping InsertionCompletion) {
        let decoratee = self.decoratee
        queue.async(flags: .barrier) {
            decoratee.insert(message, completion: completion)
        }
    }
    
    public func retrieve(contact: LocalContact, completion: @escaping RetrieveCompletion) {
        let decoratee = self.decoratee
        queue.async(flags: .barrier) {
            decoratee.retrieve(contact: contact, completion: completion)
        }
    }
}
