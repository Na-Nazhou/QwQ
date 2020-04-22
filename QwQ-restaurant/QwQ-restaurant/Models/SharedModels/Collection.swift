//
//  Collection.swift
//  QwQ-restaurant
//
//  Created by Nazhou Na on 25/3/20.
//

class Collection<T: Hashable> {
    var elements = Set<T>()

    var size: Int {
        elements.count
    }

    @discardableResult
    func add(_ element: T) -> Bool {
        let (isNew, _) = elements.insert(element)
        return isNew
    }

    @discardableResult
    func add(_ newElements: [T]) -> Bool {
        let origSize = size
        elements = elements.union(Set(newElements))
        return size > origSize
    }

    @discardableResult
    func update(_ element: T) -> Bool {
        if elements.contains(element) {
            elements.remove(element)
            elements.insert(element)
            return true
        }

        return false
    }

    func remove(_ element: T) -> Bool {
        let removed = elements.remove(element)
        return removed != nil
    }

    func contains(_ element: T) -> Bool {
        elements.contains(element)
    }

    func find(_ element: T) -> T? {
        elements.first(where: { $0 == element })
    }

    func reset() {
        elements.removeAll()
    }
}
