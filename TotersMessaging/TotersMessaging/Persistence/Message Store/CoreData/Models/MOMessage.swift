//
//  MOMessage.swift
//  TotersMessaging
//
//  Created by Husam Dayya on 05/02/2022.
//

import Foundation
import CoreData

public class MOMessage: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var text: String
    @NSManaged public var date: Date
    
    @NSManaged public var sender: MOContact
    @NSManaged public var receiver: MOContact
    
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<MOMessage> {
        NSFetchRequest<MOMessage>(entityName: className())
    }
}
