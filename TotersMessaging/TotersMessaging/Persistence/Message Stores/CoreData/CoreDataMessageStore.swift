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
        perform { context in
            do {
                _ = try MOMessage.message(from: message, in: context)
                try context.save()
                
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func retrieve(contact: LocalContact, completion: @escaping RetrieveCompletion) {
        perform { context in
            do {
                let request = MOMessage.fetchRequest()
                request.predicate = NSPredicate(format: "sender.id == %@ OR receiver.id == %@", argumentArray: [contact.id, contact.id])
                request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
                
                let localMessages = try context
                    .fetch(request)
                    .map(\.localMessage)
                
                completion(.success(localMessages))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    private func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
}
