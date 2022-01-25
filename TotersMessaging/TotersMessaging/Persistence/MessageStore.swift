//
//  MessageStore.swift
//  TotersMessaging
//
//  Created by Husam Dayya on 26/01/2022.
//

import Foundation

public protocol MessageStore {
    typealias InsertionCompletion = (Error?) -> Void
    
    func insert(_ message: Message, completion: @escaping InsertionCompletion)
}
