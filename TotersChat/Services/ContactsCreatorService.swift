//
//  ContactCreatorService.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/12/20.
//

import Foundation
import PromiseKit
import Unrealm

class ContactsCreatorService {
    
    let nameCreatorService: NamesCreatorService
    
    init() {
        nameCreatorService = NamesCreatorService()
    }
    
    private func createContact(name: String) -> Contact {
        let imageString = "person_" + String(Int.random(in: 1..<25))
        
        var contact = Contact()
        contact.name = name
        contact.image = imageString
        return contact
    }
    
    private func saveContacts(_ contacts: [Contact]) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(contacts)
        }
    }
    
    func getContacts(count: Int) -> Promise<[Contact]> {
        return Promise<[Contact]> { seal in
            
            let realm = try! Realm()
            let savedContacts = Array(realm.objects(Contact.self))
            if savedContacts.count > 0 {
                seal.fulfill(savedContacts)
                return
            }
            
            var contacts: [Contact] = []
            let names = nameCreatorService.createRandomNames(count: count)
            for name in names {
                contacts.append(createContact(name: name))
            }
            
            saveContacts(contacts)
            
            seal.fulfill(contacts)
        }
    }
}



