//
//  ObserverSet.swift
//  Workouter
//
//  Created by Uladzimir Papko on 11/13/15.
//  Copyright © 2015 visput. All rights reserved.
//

import Foundation

class ObserverSet<ObserverType>: SequenceType {
    
    var count: Int {
        return weakStorage.count
    }
    
    private let weakStorage = NSHashTable.weakObjectsHashTable()
    
    func addObserver(observer: ObserverType) {
        guard observer is AnyObject else { fatalError("Observer (\(observer)) should be subclass of AnyObject") }
        weakStorage.addObject(observer as? AnyObject)
    }
    
    func removeObserver(observer: ObserverType) {
        guard observer is AnyObject else { fatalError("Observer (\(observer)) should be subclass of AnyObject") }
        weakStorage.removeObject(observer as? AnyObject)
    }
    
    func removeAllObservers() {
        weakStorage.removeAllObjects()
    }

    func containsObserver(observer: ObserverType) -> Bool {
        guard observer is AnyObject else { fatalError("Observer (\(observer)) should be subclass of AnyObject") }
        return weakStorage.containsObject(observer as? AnyObject)
    }
    
    func generate() -> AnyGenerator<ObserverType> {
        let enumerator = weakStorage.objectEnumerator()
        return anyGenerator {
            return enumerator.nextObject() as! ObserverType?
        }
    }
}