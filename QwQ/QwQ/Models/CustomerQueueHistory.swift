class CustomerQueueHistory {
    var history = Set<QueueRecord>()

    func addToHistory(_ queueRecord: QueueRecord) {
        history.insert(queueRecord)
    }

    func addToHistory(_ records: [QueueRecord]) {
        history = history.union(Set(records))
    }
    
    func resetHistory() {
        history.removeAll()
    }
}
