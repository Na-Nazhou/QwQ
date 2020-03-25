//
//  Collection.swift
//  QwQ-restaurant
//
//  Created by Nazhou Na on 25/3/20.
//

class Collection<T: Hashable> {
    private(set) var elements = Set<T>()

    var size: Int {
        elements.count
    }

    func add(_ element: T) -> Bool {
        let (isNew, _) = elements.insert(element)
        return isNew
    }

    func add(_ newElements: [T]) -> Bool {
        let origSize = size
        elements = elements.union(Set(newElements))
        return size > origSize
    }

    func reset() {
        elements.removeAll()
    }
}

