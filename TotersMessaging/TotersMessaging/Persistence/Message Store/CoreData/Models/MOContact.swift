//
//  MOContact.swift
//  TotersMessaging
//
//  Created by Husam Dayya on 05/02/2022.
//

import Foundation
import CoreData

@objc(MOContact)
public class MOContact: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    
    @NSManaged public var messagesReceived: [MOMessage]
    @NSManaged public var messaegesSent: [MOMessage]
    
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<MOContact> {
        NSFetchRequest<MOContact>(entityName: entity().name!)
    }
}

extension MOContact {
    var localContact: LocalContact {
        LocalContact(id: id, firstName: firstName, lastName: lastName)
    }
}

extension MOContact {
    static func contact(from localContact: LocalContact, in context: NSManagedObjectContext) throws -> MOContact {
        let request = fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", argumentArray: [localContact.id])
        request.fetchLimit = 1
        
        if let foundContact = try context.fetch(request).first {
            return foundContact
        }
        
        let newContact = MOContact(context: context)
        newContact.id = localContact.id
        newContact.firstName = localContact.firstName
        newContact.lastName = localContact.lastName
        
        try context.save()
        
        return newContact
    }
}
