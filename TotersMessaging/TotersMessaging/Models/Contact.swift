//
//  Contact.swift
//  TotersMessaging
//
//  Created by Husam Dayya on 26/01/2022.
//

import Foundation

public struct Contact {
    public let id: UUID
    public let firstName: String
    public let lastName: String
    
    public init(id: UUID, firstName: String, lastName: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    }
}
