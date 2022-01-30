//
//  Contact+Extensions.swift
//  TotersMessaging
//
//  Created by Husam Dayya on 30/01/2022.
//

import Foundation

public extension Contact {
    func toLocal() -> LocalContact {
        LocalContact(id: id, firstName: firstName, lastName: lastName)
    }
}
