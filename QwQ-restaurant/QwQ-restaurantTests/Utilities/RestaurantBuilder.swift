//
//  RestaurantBuilder.swift
//  QwQ-restaurantTests
//
//  Created by Tan Su Yee on 19/4/20.
//

import Foundation
@testable import QwQ_restaurant

class RestaurantBuilder {
    var uid = "1"
    var name = "Hot tomato"
    var email = "hottomato@mail.com"
    var contact = "66156257"
    var address = "31 Jurong East"
    var menu = "Aglio olio student meal at $9!"
    var maxGroupSize = 5
    var minGroupSize = 1
    var advanceBookingLimit = 2
    var queueOpenTime: Date? = Date(timeIntervalSinceReferenceDate: 12_345)
    var queueCloseTime: Date? = Date(timeIntervalSinceReferenceDate: 12_345)
    var autoOpenTime: TimeInterval? = TimeInterval(60)
    var autoCloseTime: TimeInterval? = TimeInterval(60)
    
    init() {
    }
    
    init(uid: String, name: String, email: String, contact: String, address: String, menu: String,
         maxGroupSize: Int, minGroupSize: Int, advanceBookingLimit: Int,
         queueOpenTime: Date?, queueCloseTime: Date?,
         autoOpenTime: TimeInterval?, autoCloseTime: TimeInterval?) {
        self.uid = uid
        self.name = name
        self.email = email
        self.contact = contact
        self.address = address
        self.menu = menu
        self.queueOpenTime = queueOpenTime
        self.queueCloseTime = queueCloseTime
        self.autoOpenTime = autoOpenTime
        self.autoCloseTime = autoCloseTime
        self.maxGroupSize = maxGroupSize
        self.minGroupSize = minGroupSize
        self.advanceBookingLimit = advanceBookingLimit
    }
    
    func getDictionary() -> [String: Any] {
        [
            Constants.uidKey: uid,
            Constants.nameKey: name,
            Constants.emailKey: email,
            Constants.contactKey: contact,
            Constants.addressKey: address,
            Constants.menuKey: menu,
            Constants.maxGroupSizeKey: maxGroupSize,
            Constants.minGroupSizeKey: minGroupSize,
            Constants.advanceBookingLimitKey: advanceBookingLimit,
            Constants.queueOpenTimeKey: queueOpenTime as Any,
            Constants.queueCloseTimeKey: queueCloseTime as Any,
            Constants.autoOpenTimeKey: autoOpenTime as Any,
            Constants.autoCloseTimeKey: autoCloseTime as Any
        ] 
    }
    
    func with(uid: String) -> RestaurantBuilder {
        self.uid = uid
        return self
    }
    
    func with(name: String) -> RestaurantBuilder {
        self.name = name
        return self
    }
    
    func with(email: String) -> RestaurantBuilder {
        self.email = email
        return self
    }
    
    func with(contact: String) -> RestaurantBuilder {
        self.contact = contact
        return self
    }
    
    func with(address: String) -> RestaurantBuilder {
        self.address = address
        return self
    }
    
    func with(menu: String) -> RestaurantBuilder {
        self.menu = menu
        return self
    }
    
    func with(maxGroupSize: Int) -> RestaurantBuilder {
        self.maxGroupSize = maxGroupSize
        return self
    }
    
    func with(minGroupSize: Int) -> RestaurantBuilder {
        self.minGroupSize = minGroupSize
        return self
    }
    
    func with(advanceBookingLimit: Int) -> RestaurantBuilder {
        self.advanceBookingLimit = advanceBookingLimit
        return self
    }
    
    func with(queueOpenTime: Date) -> RestaurantBuilder {
        self.queueOpenTime = queueOpenTime
        return self
    }
    
    func with(queueCloseTime: Date) -> RestaurantBuilder {
        self.queueCloseTime = queueCloseTime
        return self
    }
    
    func with(autoOpenTime: TimeInterval) -> RestaurantBuilder {
        self.autoOpenTime = autoOpenTime
        return self
    }
    
    func with(autoCloseTime: TimeInterval) -> RestaurantBuilder {
        self.autoCloseTime = autoCloseTime
        return self
    }
    
    func build() -> Restaurant {
        Restaurant(uid: uid,
                   name: name,
                   email: email,
                   contact: contact,
                   address: address,
                   menu: menu,
                   maxGroupSize: maxGroupSize,
                   minGroupSize: minGroupSize,
                   advanceBookingLimit: advanceBookingLimit,
                   queueOpenTime: queueOpenTime,
                   queueCloseTime: queueCloseTime,
                   autoOpenTime: autoOpenTime,
                   autoCloseTime: autoCloseTime)
    }
}
