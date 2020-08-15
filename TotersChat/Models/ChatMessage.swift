//
//  ChatMessage.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/12/20.
//

import Foundation
import RealmSwift

class ChatMessage: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var text: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var isSend: Bool = false
    
    @objc dynamic var senderId: String?
    @objc dynamic var receiverId: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
