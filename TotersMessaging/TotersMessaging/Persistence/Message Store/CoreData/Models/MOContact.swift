//
//  MOContact.swift
//  TotersMessaging
//
//  Created by Husam Dayya on 05/02/2022.
//

import Foundation
import CoreData

public class MOContact: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    
    @NSManaged public var messagesReceived: [MOMessage]
    @NSManaged public var messaegesSent: [MOMessage]
    
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<MOContact> {
        NSFetchRequest<MOContact>(entityName: className())
    }
}
