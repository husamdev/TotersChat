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
    convenience init(context: NSManagedObjectContext, localContact: LocalContact) {
        self.init(context: context)
        id = localContact.id
        firstName = localContact.firstName
        lastName = localContact.lastName
    }
}

extension MOContact {
    var localContact: LocalContact {
        LocalContact(id: id, firstName: firstName, lastName: lastName)
    }
}
