//
//  BookRecordBuilder.swift
//  QwQTests
//
//  Created by Tan Su Yee on 18/4/20.
//

import Foundation
@testable import QwQ

class BookRecordBuilder {
    var id = "1"
    var restaurant = RestaurantBuilder().build()
    var customer = CustomerBuilder().build()
    var groupSize = 2
    var babyChairQuantity = 0
    var wheelchairFriendly = false
    var time = Date(timeIntervalSinceReferenceDate: 12_245)
    var admitTime: Date? = Date(timeIntervalSinceReferenceDate: 12_245)
    var serveTime: Date? = Date(timeIntervalSinceReferenceDate: 12_245)
    var rejectTime: Date? = Date(timeIntervalSinceReferenceDate: 12_245)
    var withdrawTime: Date? = Date(timeIntervalSinceReferenceDate: 12_245)
    
    init() {
    }
    
    init(id: String, restaurant: Restaurant, customer: Customer, time: Date,
         groupSize: Int, babyChairQuantity: Int, wheelchairFriendly: Bool,
         admitTime: Date? = nil, serveTime: Date? = nil,
         rejectTime: Date? = nil, withdrawTime: Date? = nil) {
        self.id = id
        self.restaurant = restaurant
        self.customer = customer
        self.groupSize = groupSize
        self.babyChairQuantity = babyChairQuantity
        self.wheelchairFriendly = wheelchairFriendly
        self.time = time
        
        self.admitTime = admitTime
        self.serveTime = serveTime
        self.rejectTime = rejectTime
        self.withdrawTime = withdrawTime
    }
    
    func getDictionary() -> [String: Any] {
        return [
            Constants.customerKey: id,
            Constants.restaurantKey: id,
            Constants.groupSizeKey: groupSize,
            Constants.babyChairQuantityKey: babyChairQuantity,
            Constants.wheelChairFriendlyKey: wheelchairFriendly,
            Constants.timeKey: time,
            Constants.admitTimeKey: admitTime as Any,
            Constants.serveTimeKey: serveTime as Any,
            Constants.rejectTimeKey: rejectTime as Any,
            Constants.withdrawTimeKey: withdrawTime as Any
            ] as [String: Any]
    }
    
    func with(id: String) -> BookRecordBuilder {
        self.id = id
        return self
    }
    
    func with(restaurant: Restaurant) -> BookRecordBuilder {
        self.restaurant = restaurant
        return self
    }
    
    func with(customer: Customer) -> BookRecordBuilder {
        self.customer = customer
        return self
    }
    
    func with(groupSize: Int) -> BookRecordBuilder {
        self.groupSize = groupSize
        return self
    }
    
    func with(babyChairQuantity: Int) -> BookRecordBuilder {
        self.babyChairQuantity = babyChairQuantity
        return self
    }
    
    func with(wheelchairFriendly: Bool) -> BookRecordBuilder {
        self.wheelchairFriendly = wheelchairFriendly
        return self
    }
    
    func with(time: Date) -> BookRecordBuilder {
        self.time = time
        return self
    }
    
    func with(admitTime: Date?) -> BookRecordBuilder {
        self.admitTime = admitTime
        return self
    }
    
    func with(serveTime: Date?) -> BookRecordBuilder {
        self.serveTime = serveTime
        return self
    }
    
    func with(rejectTime: Date?) -> BookRecordBuilder {
        self.rejectTime = rejectTime
        return self
    }
    
    func with(withdrawTime: Date?) -> BookRecordBuilder {
        self.withdrawTime = withdrawTime
        return self
    }
    
    func build() -> BookRecord {
        return BookRecord(id: id,
                          restaurant: restaurant,
                          customer: customer,
                          time: time,
                          groupSize: groupSize,
                          babyChairQuantity: babyChairQuantity,
                          wheelchairFriendly: wheelchairFriendly,
                          admitTime: admitTime,
                          serveTime: serveTime,
                          rejectTime: rejectTime,
                          withdrawTime: withdrawTime)
    }
}
