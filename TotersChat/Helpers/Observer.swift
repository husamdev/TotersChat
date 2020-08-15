//
//  Observer.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/15/20.
//

import Foundation

protocol Observer {
    var id : Int { get }
    func update<T>(with newValue: T)
}
