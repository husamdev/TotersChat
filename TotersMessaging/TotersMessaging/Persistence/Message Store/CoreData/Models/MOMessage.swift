//
//  MOMessage.swift
//  TotersMessaging
//
//  Created by Husam Dayya on 05/02/2022.
//

import Foundation
import CoreData

@objc(MOMessage)
public class MOMessage: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var text: String
    @NSManaged public var date: Date
    
    @NSManaged public var sender: MOContact
    @NSManaged public var receiver: MOContact
    
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<MOMessage> {
        NSFetchRequest<MOMessage>(entityName: entity().name!)
    }
}

extension MOMessage {
    var localMessage: LocalMessage {
        LocalMessage(id: id, message: text, date: date, sender: sender.localContact, receiver: receiver.localContact)
    }
}

extension MOMessage {
    static func message(from localMessage: LocalMessage, in context: NSManagedObjectContext) throws -> MOMessage {
        let request = fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", argumentArray: [localMessage.id])
        request.fetchLimit = 1
        
        if try context.fetch(request).first != nil {
            throw MessageAlreadyExsists()
        }
        
        let newMessage = MOMessage(context: context)
        newMessage.id = localMessage.id
        newMessage.text = localMessage.message
        newMessage.date = localMessage.date
        newMessage.sender = try MOContact.contact(from: localMessage.sender, in: context)
        newMessage.receiver = try MOContact.contact(from: localMessage.receiver, in: context)
        
        try context.save()
        
        return newMessage
    }
}

private struct MessageAlreadyExsists: Error {}
