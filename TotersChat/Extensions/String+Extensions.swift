//
//  String+Extensions.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/12/20.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
