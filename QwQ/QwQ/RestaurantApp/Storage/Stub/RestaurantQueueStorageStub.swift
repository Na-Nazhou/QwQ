import Foundation
class RestaurantQueueStorageStub: RestaurantQueueStorage, QueueStorageSync {
    weak var queueModificationLogicDelegate: QueueStorageSyncDelegate?
    weak var queueStatusLogicDelegate: QueueOpenCloseSyncDelegate?

    func openQueue(of restaurant: Restaurant, at time: Date) {
        //
    }

    func closeQueue(of restaurant: Restaurant, at time: Date) {
        //
    }

    func admitCustomer(record: QueueRecord) {
        //
    }

    func removeCustomerFromQueue(record: QueueRecord) {
        //
    }

    func serveCustomer(record: QueueRecord) {
        //
    }

    func rejectCustomer(record: QueueRecord) {
        //
    }

    func loadQueue(of restaurant: Restaurant) {
        //
    }

    func didDetectNewQueueRecord(record: QueueRecord) {
        //
    }

    func didDetectQueueRecordUpdate(old: QueueRecord, new: QueueRecord) {
        //
    }

    func didDetectWithdrawnQueueRecord(record: QueueRecord) {
        //
    }

    func didDetectAdmissionOfCustomer(record: QueueRecord) {
        //
    }

    func didDetectOpenQueue(restaurant: Restaurant) {
        //
    }

    func didDetectCloseQueue(restaurant: Restaurant) {
        //
    }
}
