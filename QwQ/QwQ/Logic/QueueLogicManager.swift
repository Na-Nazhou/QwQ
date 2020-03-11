import Foundation

class QueueLogicManager: QueueLogic {
    func enqueue(customer: Customer, to restaurant: Restaurant,
                 with groupSize: Int,
                 babyCount: Int, wheelchairCount: Int) -> String? {
        let startTime = Date()
        let newRecord = QueueRecord(customer: customer, restaurant: restaurant,
                                    groupSize: groupSize,
                                    babyCount: babyCount, wheelchairCount: wheelchairCount,
                                    startTime: startTime)
        //add to db
    }
}
