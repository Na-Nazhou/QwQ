import Foundation

class RestaurantQueue {
    private(set) var queue = RecordCollection<QueueRecord>()
    var waiting = RecordCollection<QueueRecord>()

    var openTime: Date?
    var closeTime: Date?

    func addToQueue(_ rec: QueueRecord) -> Bool {
        return queue.add(rec)
    }

    func addToWaiting(_ rec: QueueRecord) -> Bool {
        return waiting.add(rec)
    }

    func updateRecInQueue(to rec: QueueRecord) -> (didUpdate: Bool, old: QueueRecord?) {
        queue.update(to: rec)
    }
    
    func updateRecInWaiting(to rec: QueueRecord) -> (didUpdate: Bool, old: QueueRecord?) {
        waiting.update(to: rec)
    }

    func removeFromQueue(_ rec: QueueRecord) -> Bool {
        return queue.remove(rec)
    }

    func removeFromWaiting(_ rec: QueueRecord) -> Bool {
        return waiting.remove(rec)
    }
}
