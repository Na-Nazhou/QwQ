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

    func serveCustomer(record: QueueRecord) {
        //firebase clear customer from active waiting to turn up list
    }

    func rejectCustomer(record: QueueRecord) {
        //firebase reject customer from waiting to turn up list
    }

    func loadQueue(of restaurant: Restaurant, completion: @escaping (QueueRecord?) -> Void) {
        //firebase load active queue
    }

    func loadWaitingList(of restaurant: Restaurant, completion: @escaping (QueueRecord?) -> Void) {
        //firebase load active waiting list
    }

    func didDetectNewQueueRecord(record: QueueRecord) {
        queueModificationLogicDelegate?.customerDidJoinQueue(with: record)
    }

    func didDetectQueueRecordUpdate(new: QueueRecord) {
        queueModificationLogicDelegate?.customerDidUpdateQueueRecord(to: new)
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
