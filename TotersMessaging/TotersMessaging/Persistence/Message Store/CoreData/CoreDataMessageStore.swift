//
//  CoreDataMessageStore.swift
//  TotersMessaging
//
//  Created by Husam Dayya on 05/02/2022.
//

import Foundation
import CoreData

public class CoreDataMessageStore: MessageStore {
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(modalName: "MessageModel", url: storeURL, in: bundle)
        context = container.newBackgroundContext()
    }
    
    public func insert(_ message: LocalMessage, completion: @escaping InsertionCompletion) {
        
    }
    
    public func retrieve(contact: LocalContact, completion: @escaping RetrieveCompletion) {
        completion(.success([]))
    }
}
