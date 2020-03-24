class CustomerHistory<T: Record & Hashable> {
    private(set) var history = Set<T>()

    var size: Int {
        history.count
    }

    func addToHistory(_ queueRecord: T) -> Bool {
        let (isNew, _) = history.insert(queueRecord)
        return isNew
    }

    func addToHistory(_ records: [T]) -> Bool {
        let origSize = size
        history = history.union(Set(records))
        return size > origSize
    }
    
    func resetHistory() {
        history.removeAll()
    }
}
