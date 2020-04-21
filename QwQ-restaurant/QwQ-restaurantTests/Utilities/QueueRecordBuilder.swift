//
//  QueueRecordTests.swift
//  QwQ-restaurantTests
//
//  Created by Tan Su Yee on 19/4/20.
//

import Foundation
@testable import QwQ_restaurant

class QueueRecordBuilder {
    var id = "1"
    var restaurant = RestaurantBuilder().build()
    var customer = CustomerBuilder().build()
    var groupSize = 2
    var babyChairQuantity = 0
    var wheelchairFriendly = false
    var startTime = Date(timeIntervalSinceReferenceDate: 12_245)
    var admitTime: Date? = Date(timeIntervalSinceReferenceDate: 12_245)
    var serveTime: Date? = Date(timeIntervalSinceReferenceDate: 12_245)
    var rejectTime: Date? = Date(timeIntervalSinceReferenceDate: 12_245)
    var withdrawTime: Date? = Date(timeIntervalSinceReferenceDate: 12_245)
    var confirmAdmissionTime: Date? = Date(timeIntervalSinceReferenceDate: 12_245)
    var estimatedAdmitTime: Date? = Date(timeIntervalSinceReferenceDate: 12_245)
    
    init() {
    }
    
    init(id: String, restaurant: Restaurant, customer: Customer,
         groupSize: Int, babyChairQuantity: Int, wheelchairFriendly: Bool,
         startTime: Date, admitTime: Date? = nil, serveTime: Date? = nil,
         rejectTime: Date? = nil, withdrawTime: Date? = nil,
         confirmAdmissionTime: Date? = nil, estimatedAdmitTime: Date? = nil) {
        self.id = id
        self.restaurant = restaurant
        self.customer = customer
        self.groupSize = groupSize
        self.babyChairQuantity = babyChairQuantity
        self.wheelchairFriendly = wheelchairFriendly
        self.startTime = startTime
        
        self.admitTime = admitTime
        self.serveTime = serveTime
        self.rejectTime = rejectTime
        self.withdrawTime = withdrawTime
        self.confirmAdmissionTime = confirmAdmissionTime
        self.estimatedAdmitTime = estimatedAdmitTime
    }
    
    func getDictionary() -> [String: Any] {
        [
            Constants.customerKey: id,
            Constants.restaurantKey: id,
            Constants.groupSizeKey: groupSize,
            Constants.babyChairQuantityKey: babyChairQuantity,
            Constants.wheelChairFriendlyKey: wheelchairFriendly,
            Constants.startTimeKey: startTime,
            Constants.admitTimeKey: admitTime as Any,
            Constants.serveTimeKey: serveTime as Any,
            Constants.rejectTimeKey: rejectTime as Any,
            Constants.withdrawTimeKey: withdrawTime as Any,
            Constants.confirmAdmissionTimeKey: confirmAdmissionTime as Any,
            Constants.estimatedAdmitTimeKey: estimatedAdmitTime as Any
        ] 
    }
    
    func with(id: String) -> QueueRecordBuilder {
        self.id = id
        return self
    }
    
    func with(restaurant: Restaurant) -> QueueRecordBuilder {
        self.restaurant = restaurant
        return self
    }
    
    func with(customer: Customer) -> QueueRecordBuilder {
        self.customer = customer
        return self
    }
    
    func with(groupSize: Int) -> QueueRecordBuilder {
        self.groupSize = groupSize
        return self
    }
    
    func with(babyChairQuantity: Int) -> QueueRecordBuilder {
        self.babyChairQuantity = babyChairQuantity
        return self
    }
    
    func with(wheelchairFriendly: Bool) -> QueueRecordBuilder {
        self.wheelchairFriendly = wheelchairFriendly
        return self
    }
    
    func with(startTime: Date) -> QueueRecordBuilder {
        self.startTime = startTime
        return self
    }
    
    func with(admitTime: Date?) -> QueueRecordBuilder {
        self.admitTime = admitTime
        return self
    }
    
    func with(serveTime: Date?) -> QueueRecordBuilder {
        self.serveTime = serveTime
        return self
    }
    
    func with(rejectTime: Date?) -> QueueRecordBuilder {
        self.rejectTime = rejectTime
        return self
    }
    
    func with(withdrawTime: Date?) -> QueueRecordBuilder {
        self.withdrawTime = withdrawTime
        return self
    }
    
    func with(confirmAdmissionTime: Date?) -> QueueRecordBuilder {
        self.confirmAdmissionTime = confirmAdmissionTime
        return self
    }
    
    func with(estimatedAdmitTime: Date?) -> QueueRecordBuilder {
        self.estimatedAdmitTime = estimatedAdmitTime
        return self
    }
    
    func build() -> QueueRecord {
        QueueRecord(id: id,
                    restaurant: restaurant,
                    customer: customer,
                    groupSize: groupSize,
                    babyChairQuantity: babyChairQuantity,
                    wheelchairFriendly: wheelchairFriendly,
                    startTime: startTime,
                    admitTime: admitTime,
                    serveTime: serveTime,
                    rejectTime: rejectTime,
                    withdrawTime: withdrawTime,
                    confirmAdmissionTime: confirmAdmissionTime,
                    estimatedAdmitTime: estimatedAdmitTime)
    }
}
