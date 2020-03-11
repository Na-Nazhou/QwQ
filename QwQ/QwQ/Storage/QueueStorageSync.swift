import Foundation
protocol QueueStorageSync {
    var logicDelegate: QueueStorageSyncDelegate? { get set }

    func didCloseQueue(of restaurant: Restaurant, at time: Date)
    func didOpenQueue(of restaurant: Restaurant, at time: Date)
    func didAddQueueRecord(record: QueueRecord)
}
