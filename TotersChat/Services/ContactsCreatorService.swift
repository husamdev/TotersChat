//
//  ContactCreatorService.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/12/20.
//

import Foundation
import PromiseKit

class ContactsCreatorService {
    
    let nameCreatorService: NamesCreatorService
    
    init() {
        nameCreatorService = NamesCreatorService()
    }
    
    private func createContact(name: String) -> Contact {
        let id = UUID().uuidString
        let imageString = "person_" + String(Int.random(in: 1..<25))
        
        let contact = Contact(id: id, name: name, image: imageString)
        return contact
    }
    
    func createContacts(count: Int) -> Promise<[Contact]> {
        return Promise<[Contact]> { seal in
            var contacts: [Contact] = []
            let names = nameCreatorService.createRandomNames(count: count)
            for name in names {
                contacts.append(createContact(name: name))
            }
            
            seal.fulfill(contacts)
        }
    }
}



