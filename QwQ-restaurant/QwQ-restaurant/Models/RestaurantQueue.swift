import Foundation

class RestaurantQueue {
    private(set) var queue = Set<QueueRecord>()
    var waiting = Set<QueueRecord>()

    var openTime: Date?
    var closeTime: Date?

    func addToQueue(_ rec: QueueRecord) -> Bool {
        let (isNew, _) = queue.insert(rec)
        return isNew
    }

    func addToWaiting(_ rec: QueueRecord) -> Bool {
        let (isNew, _) = queue.insert(rec)
        return isNew
    }

    /// Updates and returns true and old record if is indeed updated.
    func updateRecInQueue(to rec: QueueRecord) -> (didUpdate: Bool, old: QueueRecord?) {
        //since QueueRecord is hashed only by its constants
        let old = queue.remove(rec)
        queue.insert(rec)
        if old == nil {
            assert(false, "Update should mean record already existed.")
            return (true, nil)
        }
        return (!rec.completelyIdentical(to: old!), old)
    }
    
    func updateRecInWaiting(to rec: QueueRecord) -> (didUpdate: Bool, old: QueueRecord?) {
        //since QueueRecord is hashed only by its constants
        let old = waiting.remove(rec)
        waiting.insert(rec)
        if old == nil {
            assert(false, "Update should mean record already existed.")
            return (true, rec)
        }
        return (!rec.completelyIdentical(to: old!), old)
    }

    func removeFromQueue(_ rec: QueueRecord) -> Bool {
        let removed = queue.remove(rec)
        return removed != nil
    }

    func removeFromWaiting(_ rec: QueueRecord) -> Bool {
        let removed = queue.remove(rec)
        return removed != nil
    }
}
