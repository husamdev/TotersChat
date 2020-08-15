//
//  Subject.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/15/20.
//

import Foundation

class Subject<T> {
    
    private var _value : T! = nil
    private var _observers : [Observer] = []
    
    var value : T {
        get {
            return self._value
        }
        set {
            self._value = newValue
            self.notify(with: newValue)
        }
    }
    
    var observers : [Observer] {
        get {
            return self._observers
        }
        set {
            self._observers = newValue
        }
    }
    
    func addObserver(observer: Observer) {
        observers.append(observer)
    }
    
    func removeObserver(observer: Observer) {
        observers = observers.filter({$0.id != observer.id})
    }
    
    func notify<T>(with newValue: T) {
        for observer in observers {
            observer.update(with: newValue)
        }
    }
}
