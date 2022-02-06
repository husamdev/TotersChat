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
    convenience init(context: NSManagedObjectContext, localMessage: LocalMessage) {
        self.init(context: context)
        id = localMessage.id
        text = localMessage.message
        date = localMessage.date
        sender = MOContact(context: context, localContact: localMessage.sender)
        receiver = MOContact(context: context, localContact: localMessage.receiver)
    }
}

extension MOMessage {
    var localMessage: LocalMessage {
        LocalMessage(id: id, message: text, date: date, sender: sender.localContact, receiver: receiver.localContact)
    }
}
