//
//  MessageStore.swift
//  TotersMessaging
//
//  Created by Husam Dayya on 26/01/2022.
//

import Foundation

public protocol MessageStore {
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrieveCompletion = (Result<[LocalMessage], Error>) -> Void
    
    func insert(_ message: LocalMessage, completion: @escaping InsertionCompletion)
    
    func retrieve(contact: LocalContact, completion: @escaping RetrieveCompletion)
}
