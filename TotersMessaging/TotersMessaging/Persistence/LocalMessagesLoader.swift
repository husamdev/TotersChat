//
//  LocalMessagesLoader.swift
//  TotersMessaging
//
//  Created by Husam Dayya on 26/01/2022.
//

import Foundation

public class LocalMessagesLoader {
    
    public typealias SaveResult = Error?
    public typealias LoadResult = Result<[Message], Error>
    
    private let store: MessageStore
    
    public init(store: MessageStore) {
        self.store = store
    }
    
    public func save(_ message: Message, completion: @escaping (SaveResult) -> Void) {
        store.insert(message.toLocal()) { [weak self] insertionError in
            guard self != nil else { return }
            
            completion(insertionError)
        }
    }
    
    public func loadMessages(with contact: Contact, completion: @escaping (LoadResult) -> Void) {
        store.retrieve(contact: contact.toLocal()) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success(localMessages):
                completion(.success(localMessages.toModels()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
