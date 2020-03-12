import Foundation
/// Stub class of storage/firebase adapter.
class RestaurantQueueStorageStub: RestaurantQueueStorage, QueueStorageSync {
    weak var queueModificationLogicDelegate: QueueStorageSyncDelegate?
    weak var queueStatusLogicDelegate: QueueOpenCloseSyncDelegate?

    func openQueue(of restaurant: Restaurant, at time: Date) {
        //firebase open queue
    }

    func closeQueue(of restaurant: Restaurant, at time: Date) {
        //firebase close queue
    }

    func admitCustomer(record: QueueRecord) {
        //firebase admit customer
    }

    func removeCustomerFromQueue(record: QueueRecord) {
        //firebase remove customer
    }

    func serveCustomer(record: QueueRecord) {
        //firebase clear customer from active waiting to turn up list
    }

    func rejectCustomer(record: QueueRecord) {
        //firebase reject customer from waiting to turn up list
    }

    func loadQueue(of restaurant: Restaurant) -> [QueueRecord] {
        //firebase load active queue
        return []
    }

    func loadWaitingList(of restaurant: Restaurant) -> [QueueRecord] {
        //firebase load active waiting list
        return []
    }

    func didDetectNewQueueRecord(record: QueueRecord) {
        queueModificationLogicDelegate?.customerDidJoinQueue(with: record)
    }

    func didDetectQueueRecordUpdate(old: QueueRecord, new: QueueRecord) {
        queueModificationLogicDelegate?.customerDidUpdateQueueRecord(from: old, to: new)
    }

    func didDetectWithdrawnQueueRecord(record: QueueRecord) {
        queueModificationLogicDelegate?.customerDidWithdrawQueue(record: record)
    }

    func didDetectAdmissionOfCustomer(record: QueueRecord) {
        queueModificationLogicDelegate?.restaurantDidAdmitCustomer(record: record)
    }

    func didDetectServiceOfCustomer(record: QueueRecord) {
        queueModificationLogicDelegate?.restaurantDidServeCustomer(record: record)
    }

    func didDetectRejectionOfCustomer(record: QueueRecord) {
        queueModificationLogicDelegate?.restaurantDidRejectCustomer(record: record)
    }

    func didDetectOpenQueue(restaurant: Restaurant) {
        queueStatusLogicDelegate?.restaurantDidOpenQueue(restaurant: restaurant)
    }

    func didDetectCloseQueue(restaurant: Restaurant) {
        queueStatusLogicDelegate?.restaurantDidCloseQueue(restaurant: restaurant)
    }
}
