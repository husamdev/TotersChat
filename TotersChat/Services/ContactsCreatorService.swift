//
//  ContactCreatorService.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/12/20.
//

import Foundation
import RealmSwift
import PromiseKit

/// Service responsible for creating, retreiving, and saving contacts
class ContactsCreatorService {
    
    let nameCreatorService = NamesCreatorService()
    
    /// Creates a contact object from name and random image name that is saved in the assets folder
    private func createContact(name: String) -> Contact {
        let imageString = "person_" + String(Int.random(in: 1..<25))
        
        let contact = Contact()
        contact.name = name
        contact.image = imageString
        return contact
    }
    
    /// Saves a list of contacts into realm database
    private func saveContacts(_ contacts: [Contact]) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(contacts)
        }
    }
    
    /// Fetches contacts from realm database
    func getContacts() -> Results<Contact> {
        let realm = try! Realm()
        let savedContacts = realm.objects(Contact.self)
        return savedContacts
    }
    
    /// Creates new contacts after getting random names, then saves them into realm database, if there is no saved contacts
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
