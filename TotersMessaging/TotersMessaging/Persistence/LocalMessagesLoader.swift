//
//  LocalMessagesLoader.swift
//  TotersMessaging
//
//  Created by Husam Dayya on 26/01/2022.
//

import Foundation

public class LocalMessagesLoader {
    
    public typealias SaveResult = Error?
    
    private let store: MessageStore
    
    public init(store: MessageStore) {
        self.store = store
    }
    
    public func save(_ message: Message, completion: @escaping (SaveResult) -> Void) {
        store.insert(message) { [weak self] insertionError in
            guard self != nil else { return }
            
            completion(insertionError)
        }
    }
    
    public func load() {
        store.retrieve() 
    }
}
