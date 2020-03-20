class CustomerQueueHistory {
    private(set) var history = Set<QueueRecord>()
    var size: Int {
        history.count
    }

    func addToHistory(_ queueRecord: QueueRecord) -> Bool {
        let (isNew, _) = history.insert(queueRecord)
        return isNew
    }

    func addToHistory(_ records: [QueueRecord]) -> Bool {
        let origSize = size
        history = history.union(Set(records))
        return size > origSize
    }
    
    func resetHistory() {
        history.removeAll()
    }
}
