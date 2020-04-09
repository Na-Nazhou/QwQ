class Collection<T: Hashable> {
    var elements = Set<T>()

    var size: Int {
        elements.count
    }

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

    @discardableResult
    func remove(_ element: T) -> Bool {
        let removed = elements.remove(element)
        return removed != nil
    }

    func reset() {
        elements.removeAll()
    }
}
