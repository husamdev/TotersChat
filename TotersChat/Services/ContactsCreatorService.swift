//
//  ContactCreatorService.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/12/20.
//

import Foundation
import RealmSwift
import PromiseKit

class ContactsCreatorService {
    
    let nameCreatorService: NamesCreatorService
    
    init() {
        nameCreatorService = NamesCreatorService()
    }
    
    private func createContact(name: String) -> Contact {
        let imageString = "person_" + String(Int.random(in: 1..<25))
        
        let contact = Contact()
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
    
    func getContacts() -> Results<Contact> {
        let realm = try! Realm()
        let savedContacts = realm.objects(Contact.self)
        return savedContacts
    }
    
    func createContacts(count: Int = 200) -> Promise<[Contact]> {
        return Promise { seal in
            
            let savedContacts = getContacts()
            if !savedContacts.isEmpty {
                seal.resolve(Array(savedContacts), nil)
                return
            }
            
            var contacts: [Contact] = []
            let names = nameCreatorService.createRandomNames(count: 200)
            for name in names {
                contacts.append(createContact(name: name))
            }
            
            saveContacts(contacts)
            seal.fulfill(contacts)
        }
    }
    
}
