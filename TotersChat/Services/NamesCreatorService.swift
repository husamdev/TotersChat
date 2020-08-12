//
//  NameCreatorService.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/12/20.
//

import Foundation

class NamesCreatorService {
    
    let firstNameSyllables = ["mon", "fay", "shi", "zay", "blarg", "rash", "izen", "taw", "jay", "leo", "gus"]
    
    let lastNameSyllables = ["malo", "zak", "man", "abo", "bet", "wonk", "ian", "yong", "ley", "yes"]
    
    let nameSuffixes = ["son", "li", "ssen", "kor", "III", "OBE", "and", "so", "on"]
    
    private func createFirstName() -> String {
        // creates a first name with 2-3 syllables
        var firstName: String = "";
        let numberOfSyllablesInFirstName = Int.random(in: 2 ..< 4)
        
        for _ in 0..<numberOfSyllablesInFirstName {
            let randomNumber = Int.random(in: 0 ..< firstNameSyllables.count - 1)
            firstName += firstNameSyllables[randomNumber]
        }
        
        firstName.capitalizeFirstLetter()
        return firstName
    }
    
    private func createLastName() -> String {
        // creates a last name with 1-2 syllables
        var lastName: String = "";
        let numberOfSyllablesInLastName = Int.random(in: 1 ..< 3)
        for _ in 0..<numberOfSyllablesInLastName {
            let randomNumber = Int.random(in: 0 ..< lastNameSyllables.count - 1)
            lastName += lastNameSyllables[randomNumber];
        }
        
        lastName.capitalizeFirstLetter()
        return lastName
    }
    
    private func createNewName() -> String {
        var fullName = createFirstName() + " " + createLastName()
        
        //adds a suffix to the last name with a chance of 50%
        if Int.random(in: 0..<100) < 50 {
            let randomNumber = Int.random(in: 0..<nameSuffixes.count - 1)
            fullName += nameSuffixes[randomNumber]
        }
        
        return fullName
    }
    
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
