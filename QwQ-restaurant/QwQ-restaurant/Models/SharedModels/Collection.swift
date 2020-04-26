/// A collection of hashable objects.
class Collection<T: Hashable> {
    var elements = Set<T>()

    var size: Int {
        elements.count
    }

    /// Adds `element` to collection and returns true if there did not exist the same element in this collection.
    @discardableResult
    func add(_ element: T) -> Bool {
        let (isNew, _) = elements.insert(element)
        return isNew
    }

    /// Adds `newElements` to collection and returns true if elements are added to this collection.
    @discardableResult
    func add(_ newElements: [T]) -> Bool {
        let origSize = size
        elements = elements.union(Set(newElements))
        return size > origSize
    }

    /// Updates the same element as `element` in this collection to `element` and returns true if `element`
    /// exists in collection.
    /// Else does not update and returns false.
    @discardableResult
    func update(_ element: T) -> Bool {
        if elements.contains(element) {
            elements.remove(element)
            elements.insert(element)
            return true
        }

        return false
    }

    /// Removes `element` from thhis collection and returns  true if something is removed.
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
