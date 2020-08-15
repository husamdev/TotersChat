//
//  Contact.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/12/20.
//

import Foundation
import RealmSwift

class Contact: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var image: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var me: Contact  = {
        let me = Contact()
        me.id = "0"
        me.name = "husam"
        me.image = "person_1"
        return me
    }()
}
