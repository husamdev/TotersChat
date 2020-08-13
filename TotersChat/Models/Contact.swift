//
//  Contact.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/12/20.
//

import Foundation
import Unrealm

struct Contact: Realmable {
    var id: String = UUID().uuidString
    var name: String = ""
    var image: String = ""
}
