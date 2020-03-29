class Collection<T: Hashable> {
    var elements = Set<T>()

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

    func update(_ element: T) {
        elements.remove(element)
        elements.insert(element)
    }

    func remove(_ element: T) -> Bool {
        let removed = elements.remove(element)
        return removed != nil
    }
    
    func reset() {
        elements.removeAll()
    }

    func getOriginalElement(of element: T) -> T {
        precondition(elements.contains(element), "Given element should exist in the first place.")
        let (_, orig) = elements.insert(element)
        return orig
    }
}
