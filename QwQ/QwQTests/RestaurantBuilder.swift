//
//  RestaurantBuilder.swift
//  QwQTests
//
//  Created by Tan Su Yee on 18/4/20.
//

import Foundation
@testable import QwQ

struct RestaurantBuilder {
    static let uid = "1"
    static let name = "Hot tomato"
    static let email = "hottomato@mail.com"
    static let contact = "66156257"
    static let address = "31 Jurong East"
    static let menu = "Aglio olio student meal at $9!"
    static let maxGroupSize = 5
    static let minGroupSize = 1
    static let advanceBookingLimit = 2
    static let queueOpenTime = Date()
    static let queueCloseTime = Date()
    static let autoOpenTime = TimeInterval(60)
    static let autoCloseTime = TimeInterval(60)
    
    static func build() -> Restaurant {
        return Restaurant(uid: RestaurantBuilder.uid,
                          name: RestaurantBuilder.name,
                          email: RestaurantBuilder.email,
                          contact: RestaurantBuilder.contact,
                          address: RestaurantBuilder.address,
                          menu: RestaurantBuilder.menu,
                          maxGroupSize: RestaurantBuilder.maxGroupSize,
                          minGroupSize: RestaurantBuilder.minGroupSize,
                          advanceBookingLimit: RestaurantBuilder.advanceBookingLimit,
                          queueOpenTime: RestaurantBuilder.queueOpenTime,
                          queueCloseTime: RestaurantBuilder.queueCloseTime,
                          autoOpenTime: RestaurantBuilder.autoOpenTime,
                          autoCloseTime: RestaurantBuilder.autoCloseTime)
    }
    
    static func with(uid: String) -> Restaurant {
        return Restaurant(uid: uid,
                          name: name,
                          email: RestaurantBuilder.email,
                          contact: RestaurantBuilder.contact,
                          address: RestaurantBuilder.address,
                          menu: RestaurantBuilder.menu,
                          maxGroupSize: RestaurantBuilder.maxGroupSize,
                          minGroupSize: RestaurantBuilder.minGroupSize,
                          advanceBookingLimit: RestaurantBuilder.advanceBookingLimit,
                          queueOpenTime: RestaurantBuilder.queueOpenTime,
                          queueCloseTime: RestaurantBuilder.queueCloseTime,
                          autoOpenTime: RestaurantBuilder.autoOpenTime,
                          autoCloseTime: RestaurantBuilder.autoCloseTime)
    }
    
    static func with(name: String) -> Restaurant {
        return Restaurant(uid: RestaurantBuilder.uid,
                          name: name,
                          email: RestaurantBuilder.email,
                          contact: RestaurantBuilder.contact,
                          address: RestaurantBuilder.address,
                          menu: RestaurantBuilder.menu,
                          maxGroupSize: RestaurantBuilder.maxGroupSize,
                          minGroupSize: RestaurantBuilder.minGroupSize,
                          advanceBookingLimit: RestaurantBuilder.advanceBookingLimit,
                          queueOpenTime: RestaurantBuilder.queueOpenTime,
                          queueCloseTime: RestaurantBuilder.queueCloseTime,
                          autoOpenTime: RestaurantBuilder.autoOpenTime,
                          autoCloseTime: RestaurantBuilder.autoCloseTime)
    }
    
    static func with(email: String) -> Restaurant {
        return Restaurant(uid: RestaurantBuilder.uid,
                          name: RestaurantBuilder.name,
                          email: email,
                          contact: RestaurantBuilder.contact,
                          address: RestaurantBuilder.address,
                          menu: RestaurantBuilder.menu,
                          maxGroupSize: RestaurantBuilder.maxGroupSize,
                          minGroupSize: RestaurantBuilder.minGroupSize,
                          advanceBookingLimit: RestaurantBuilder.advanceBookingLimit,
                          queueOpenTime: RestaurantBuilder.queueOpenTime,
                          queueCloseTime: RestaurantBuilder.queueCloseTime,
                          autoOpenTime: RestaurantBuilder.autoOpenTime,
                          autoCloseTime: RestaurantBuilder.autoCloseTime)
    }
    
    static func with(contact: String) -> Restaurant {
        return Restaurant(uid: RestaurantBuilder.uid,
                          name: RestaurantBuilder.name,
                          email: RestaurantBuilder.email,
                          contact: contact,
                          address: RestaurantBuilder.address,
                          menu: RestaurantBuilder.menu,
                          maxGroupSize: RestaurantBuilder.maxGroupSize,
                          minGroupSize: RestaurantBuilder.minGroupSize,
                          advanceBookingLimit: RestaurantBuilder.advanceBookingLimit,
                          queueOpenTime: RestaurantBuilder.queueOpenTime,
                          queueCloseTime: RestaurantBuilder.queueCloseTime,
                          autoOpenTime: RestaurantBuilder.autoOpenTime,
                          autoCloseTime: RestaurantBuilder.autoCloseTime)
    }
    
    static func with(address: String) -> Restaurant {
        return Restaurant(uid: RestaurantBuilder.uid,
                          name: RestaurantBuilder.name,
                          email: RestaurantBuilder.email,
                          contact: RestaurantBuilder.contact,
                          address: address,
                          menu: RestaurantBuilder.menu,
                          maxGroupSize: RestaurantBuilder.maxGroupSize,
                          minGroupSize: RestaurantBuilder.minGroupSize,
                          advanceBookingLimit: RestaurantBuilder.advanceBookingLimit,
                          queueOpenTime: RestaurantBuilder.queueOpenTime,
                          queueCloseTime: RestaurantBuilder.queueCloseTime,
                          autoOpenTime: RestaurantBuilder.autoOpenTime,
                          autoCloseTime: RestaurantBuilder.autoCloseTime)
    }
    
    static func with(menu: String) -> Restaurant {
        return Restaurant(uid: RestaurantBuilder.uid,
                          name: RestaurantBuilder.name,
                          email: RestaurantBuilder.email,
                          contact: RestaurantBuilder.contact,
                          address: RestaurantBuilder.address,
                          menu: menu,
                          maxGroupSize: RestaurantBuilder.maxGroupSize,
                          minGroupSize: RestaurantBuilder.minGroupSize,
                          advanceBookingLimit: RestaurantBuilder.advanceBookingLimit,
                          queueOpenTime: RestaurantBuilder.queueOpenTime,
                          queueCloseTime: RestaurantBuilder.queueCloseTime,
                          autoOpenTime: RestaurantBuilder.autoOpenTime,
                          autoCloseTime: RestaurantBuilder.autoCloseTime)
    }
    
    static func with(maxGroupSize: Int) -> Restaurant {
        return Restaurant(uid: RestaurantBuilder.uid,
                          name: RestaurantBuilder.name,
                          email: RestaurantBuilder.email,
                          contact: RestaurantBuilder.contact,
                          address: RestaurantBuilder.address,
                          menu: RestaurantBuilder.menu,
                          maxGroupSize: maxGroupSize,
                          minGroupSize: RestaurantBuilder.minGroupSize,
                          advanceBookingLimit: RestaurantBuilder.advanceBookingLimit,
                          queueOpenTime: RestaurantBuilder.queueOpenTime,
                          queueCloseTime: RestaurantBuilder.queueCloseTime,
                          autoOpenTime: RestaurantBuilder.autoOpenTime,
                          autoCloseTime: RestaurantBuilder.autoCloseTime)
    }
    
    static func with(minGroupSize: Int) -> Restaurant {
        return Restaurant(uid: RestaurantBuilder.uid,
                          name: RestaurantBuilder.name,
                          email: RestaurantBuilder.email,
                          contact: RestaurantBuilder.contact,
                          address: RestaurantBuilder.address,
                          menu: RestaurantBuilder.menu,
                          maxGroupSize: RestaurantBuilder.maxGroupSize,
                          minGroupSize: minGroupSize,
                          advanceBookingLimit: RestaurantBuilder.advanceBookingLimit,
                          queueOpenTime: RestaurantBuilder.queueOpenTime,
                          queueCloseTime: RestaurantBuilder.queueCloseTime,
                          autoOpenTime: RestaurantBuilder.autoOpenTime,
                          autoCloseTime: RestaurantBuilder.autoCloseTime)
    }
    
    static func with(advanceBookingLimit: Int) -> Restaurant {
        return Restaurant(uid: RestaurantBuilder.uid,
                          name: RestaurantBuilder.name,
                          email: RestaurantBuilder.email,
                          contact: RestaurantBuilder.contact,
                          address: RestaurantBuilder.address,
                          menu: RestaurantBuilder.menu,
                          maxGroupSize: RestaurantBuilder.maxGroupSize,
                          minGroupSize: RestaurantBuilder.minGroupSize,
                          advanceBookingLimit: advanceBookingLimit,
                          queueOpenTime: RestaurantBuilder.queueOpenTime,
                          queueCloseTime: RestaurantBuilder.queueCloseTime,
                          autoOpenTime: RestaurantBuilder.autoOpenTime,
                          autoCloseTime: RestaurantBuilder.autoCloseTime)
    }
    
    static func with(queueOpenTime: Date) -> Restaurant {
        return Restaurant(uid: RestaurantBuilder.uid,
                          name: RestaurantBuilder.name,
                          email: RestaurantBuilder.email,
                          contact: RestaurantBuilder.contact,
                          address: RestaurantBuilder.address,
                          menu: RestaurantBuilder.menu,
                          maxGroupSize: RestaurantBuilder.maxGroupSize,
                          minGroupSize: RestaurantBuilder.minGroupSize,
                          advanceBookingLimit: RestaurantBuilder.advanceBookingLimit,
                          queueOpenTime: RestaurantBuilder.queueOpenTime,
                          queueCloseTime: RestaurantBuilder.queueCloseTime,
                          autoOpenTime: RestaurantBuilder.autoOpenTime,
                          autoCloseTime: RestaurantBuilder.autoCloseTime)
    }
    
    static func with(queueCloseTime: Date) -> Restaurant {
        return Restaurant(uid: RestaurantBuilder.uid,
                          name: RestaurantBuilder.name,
                          email: RestaurantBuilder.email,
                          contact: RestaurantBuilder.contact,
                          address: RestaurantBuilder.address,
                          menu: RestaurantBuilder.menu,
                          maxGroupSize: RestaurantBuilder.maxGroupSize,
                          minGroupSize: RestaurantBuilder.minGroupSize,
                          advanceBookingLimit: RestaurantBuilder.advanceBookingLimit,
                          queueOpenTime: RestaurantBuilder.queueOpenTime,
                          queueCloseTime: RestaurantBuilder.queueCloseTime,
                          autoOpenTime: RestaurantBuilder.autoOpenTime,
                          autoCloseTime: RestaurantBuilder.autoCloseTime)
    }
    
    static func with(autoOpenTime: TimeInterval) -> Restaurant {
        return Restaurant(uid: RestaurantBuilder.uid,
                          name: RestaurantBuilder.name,
                          email: RestaurantBuilder.email,
                          contact: RestaurantBuilder.contact,
                          address: RestaurantBuilder.address,
                          menu: RestaurantBuilder.menu,
                          maxGroupSize: RestaurantBuilder.maxGroupSize,
                          minGroupSize: RestaurantBuilder.minGroupSize,
                          advanceBookingLimit: RestaurantBuilder.advanceBookingLimit,
                          queueOpenTime: RestaurantBuilder.queueOpenTime,
                          queueCloseTime: RestaurantBuilder.queueCloseTime,
                          autoOpenTime: RestaurantBuilder.autoOpenTime,
                          autoCloseTime: RestaurantBuilder.autoCloseTime)
    }
    
    static func with(autoCloseTime: TimeInterval) -> Restaurant {
        return Restaurant(uid: RestaurantBuilder.uid,
                          name: RestaurantBuilder.name,
                          email: RestaurantBuilder.email,
                          contact: RestaurantBuilder.contact,
                          address: RestaurantBuilder.address,
                          menu: RestaurantBuilder.menu,
                          maxGroupSize: RestaurantBuilder.maxGroupSize,
                          minGroupSize: RestaurantBuilder.minGroupSize,
                          advanceBookingLimit: RestaurantBuilder.advanceBookingLimit,
                          queueOpenTime: RestaurantBuilder.queueOpenTime,
                          queueCloseTime: RestaurantBuilder.queueCloseTime,
                          autoOpenTime: RestaurantBuilder.autoOpenTime,
                          autoCloseTime: RestaurantBuilder.autoCloseTime)
    }
}
