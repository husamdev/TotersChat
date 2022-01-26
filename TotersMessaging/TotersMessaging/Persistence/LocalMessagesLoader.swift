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
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
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

public extension Message {
    func toLocal() -> LocalMessage {
        LocalMessage(id: id, message: message, date: date, sender: sender.toLocal(), receiver: receiver.toLocal())
    }
}

public extension Array where Element == LocalMessage {
    func toModels() -> [Message] {
        map { $0.toModel() }
    }
}

public extension Contact {
    func toLocal() -> LocalContact {
        LocalContact(id: id, firstName: firstName, lastName: lastName)
    }
}
