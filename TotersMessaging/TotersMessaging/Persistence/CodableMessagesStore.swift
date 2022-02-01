//
//  CodableMessagesStore.swift
//  TotersMessaging
//
//  Created by Husam Dayya on 01/02/2022.
//

import Foundation

public class CodableMessagesStore: MessageStore {
    private struct Cache: Codable {
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
    
    private struct MessageAlreadySavedToStore: Error {}
    
    private let storeURL: URL
    
    public init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    public func retrieve(contact: LocalContact, completion: @escaping MessageStore.RetrieveCompletion) {
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
    
    public func insert(_ message: LocalMessage, completion: @escaping MessageStore.InsertionCompletion) {
        do {
            let cachedLocalMessages = try cachedLocalMessages()
            
            guard !cachedLocalMessages.contains(message) else {
                throw MessageAlreadySavedToStore()
            }
            
            let root = Cache(localMessages: cachedLocalMessages + [message])
            let json = try JSONEncoder().encode(root)
            try json.write(to: storeURL)
            
            completion(nil)
        } catch {
            completion(error)
        }
    }
}

extension CodableMessagesStore {
    private func cachedLocalMessages() throws -> [LocalMessage] {
        guard let data = try? Data(contentsOf: storeURL) else {
            return []
        }
        
        let root = try JSONDecoder().decode(Cache.self, from: data)
        return root.localMessages
    }
}

extension LocalMessage {
    func isWithContact(_ contact: LocalContact) -> Bool {
        receiver == contact || sender == contact
    }
}
