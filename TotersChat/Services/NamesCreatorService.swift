//
//  NameCreatorService.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/12/20.
//

import Foundation

/// Service responsible for creating random names
class NamesCreatorService {
    
    let firstNameSyllables = ["mon", "fay", "shi", "zay", "blarg", "rash", "izen", "taw", "jay", "leo", "gus"]
    
    let lastNameSyllables = ["malo", "zak", "man", "abo", "bet", "wonk", "ian", "yong", "ley", "yes"]
    
    let nameSuffixes = ["son", "li", "ssen", "kor", "III", "OBE", "and", "so", "on"]
    
    /// Creates first name from 2 or 3 syllables
    private func createFirstName() -> String {
        var firstName: String = "";
        let numberOfSyllablesInFirstName = Int.random(in: 2 ..< 4)
        
        for _ in 0..<numberOfSyllablesInFirstName {
            let randomNumber = Int.random(in: 0 ..< firstNameSyllables.count - 1)
            firstName += firstNameSyllables[randomNumber]
        }
        
        firstName.capitalizeFirstLetter()
        return firstName
    }
    
    /// Creates last name from 1 or 2 syllables
    private func createLastName() -> String {
        var lastName: String = "";
        let numberOfSyllablesInLastName = Int.random(in: 1 ..< 3)
        for _ in 0..<numberOfSyllablesInLastName {
            let randomNumber = Int.random(in: 0 ..< lastNameSyllables.count - 1)
            lastName += lastNameSyllables[randomNumber];
        }
        
        lastName.capitalizeFirstLetter()
        return lastName
    }
    
    /// Creates a full name
    private func createNewName() -> String {
        var fullName = createFirstName() + " " + createLastName()
        
        //adds a suffix to the last name with a chance of 50%
        if Int.random(in: 0..<100) < 50 {
            let randomNumber = Int.random(in: 0..<nameSuffixes.count - 1)
            fullName += nameSuffixes[randomNumber]
        }
        
        return fullName
    }
    
    /// Creates a list of random names without duplicates
    public func createRandomNames(count: Int) -> [String] {
        var names: [String] = []
        
        while names.count < count {
            let name = createNewName()
            if names.contains(name) == false {
                names.append(name)
            }
        }
        
        return names
    }
}
