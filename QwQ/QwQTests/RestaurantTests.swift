//
//  RestaurantTests.swift
//  QwQTests
//
//  Created by Tan Su Yee on 18/4/20.
//

import XCTest
@testable import QwQ

class RestaurantTests: XCTestCase {
    var restaurant: Restaurant!
    var restaurantFromDictionary: Restaurant?
    let dictionary = [
        Constants.uidKey: defaultRestaurant.uid,
        Constants.nameKey: defaultRestaurant.name,
        Constants.emailKey: defaultRestaurant.email,
        Constants.contactKey: defaultRestaurant.contact,
        Constants.addressKey: defaultRestaurant.address,
        Constants.menuKey: defaultRestaurant.menu,
        Constants.maxGroupSizeKey: defaultRestaurant.maxGroupSize,
        Constants.minGroupSizeKey: defaultRestaurant.minGroupSize,
        Constants.advanceBookingLimitKey: defaultRestaurant.advanceBookingLimit,
        Constants.queueOpenTimeKey: defaultRestaurant.queueOpenTime,
        Constants.queueCloseTimeKey: defaultRestaurant.queueCloseTime,
        Constants.autoOpenTimeKey: defaultRestaurant.autoOpenTime,
        Constants.autoCloseTimeKey: defaultRestaurant.autoCloseTime
        ] as [String : Any]
    
    override func setUp() {
        super.setUp()
        restaurant = Restaurant(uid: defaultRestaurant.uid,
                                name: defaultRestaurant.name,
                                email: defaultRestaurant.email,
                                contact: defaultRestaurant.contact,
                                address: defaultRestaurant.address,
                                menu: defaultRestaurant.menu,
                                maxGroupSize: defaultRestaurant.maxGroupSize,
                                minGroupSize: defaultRestaurant.minGroupSize,
                                advanceBookingLimit: defaultRestaurant.advanceBookingLimit,
                                queueOpenTime: defaultRestaurant.queueOpenTime,
                                queueCloseTime: defaultRestaurant.queueCloseTime,
                                autoOpenTime: defaultRestaurant.autoOpenTime,
                                autoCloseTime: defaultRestaurant.autoCloseTime)
        restaurantFromDictionary = Restaurant(dictionary: dictionary)
    }
    
    func testInit() {
        XCTAssertEqual(restaurant.uid, dictionary[Constants.uidKey] as? String)
        XCTAssertEqual(restaurant.name, dictionary[Constants.nameKey] as? String)
        XCTAssertEqual(restaurant.email, dictionary[Constants.emailKey] as? String)
        XCTAssertEqual(restaurant.contact, dictionary[Constants.contactKey] as? String)
    }
    
    func testDictionaryInit() {
        XCTAssertEqual(restaurantFromDictionary, restaurant)
    }
    
    func testEqual_sameId_isEqual() {
        let otherRestaurant = Restaurant(uid: defaultRestaurant.uid,
                                         name: defaultRestaurant.name,
                                         email: defaultRestaurant.email,
                                         contact: defaultRestaurant.contact,
                                         address: defaultRestaurant.address,
                                         menu: defaultRestaurant.menu,
                                         maxGroupSize: defaultRestaurant.maxGroupSize,
                                         minGroupSize: defaultRestaurant.minGroupSize,
                                         advanceBookingLimit: defaultRestaurant.advanceBookingLimit,
                                         queueOpenTime: defaultRestaurant.queueOpenTime,
                                         queueCloseTime: defaultRestaurant.queueCloseTime,
                                         autoOpenTime: defaultRestaurant.autoOpenTime,
                                         autoCloseTime: defaultRestaurant.autoCloseTime)
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentId_isnotEqual() {
        let otherRestaurant = Restaurant(uid: "2",
                                         name: defaultRestaurant.name,
                                         email: defaultRestaurant.email,
                                         contact: defaultRestaurant.contact,
                                         address: defaultRestaurant.address,
                                         menu: defaultRestaurant.menu,
                                         maxGroupSize: defaultRestaurant.maxGroupSize,
                                         minGroupSize: defaultRestaurant.minGroupSize,
                                         advanceBookingLimit: defaultRestaurant.advanceBookingLimit,
                                         queueOpenTime: defaultRestaurant.queueOpenTime,
                                         queueCloseTime: defaultRestaurant.queueCloseTime,
                                         autoOpenTime: defaultRestaurant.autoOpenTime,
                                         autoCloseTime: defaultRestaurant.autoCloseTime)
        XCTAssertFalse(otherRestaurant == restaurant)
    }
    
    func testEqual_differentName_isEqual() {
        let otherRestaurant = Restaurant(uid: defaultRestaurant.uid,
                                         name: "Saizerya",
                                         email: defaultRestaurant.email,
                                         contact: defaultRestaurant.contact,
                                         address: defaultRestaurant.address,
                                         menu: defaultRestaurant.menu,
                                         maxGroupSize: defaultRestaurant.maxGroupSize,
                                         minGroupSize: defaultRestaurant.minGroupSize,
                                         advanceBookingLimit: defaultRestaurant.advanceBookingLimit,
                                         queueOpenTime: defaultRestaurant.queueOpenTime,
                                         queueCloseTime: defaultRestaurant.queueCloseTime,
                                         autoOpenTime: defaultRestaurant.autoOpenTime,
                                         autoCloseTime: defaultRestaurant.autoCloseTime)
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentEmail_isEqual() {
        let otherRestaurant = Restaurant(uid: defaultRestaurant.uid,
                                         name: defaultRestaurant.name,
                                         email: "saizerya@mail.com",
                                         contact: defaultRestaurant.contact,
                                         address: defaultRestaurant.address,
                                         menu: defaultRestaurant.menu,
                                         maxGroupSize: defaultRestaurant.maxGroupSize,
                                         minGroupSize: defaultRestaurant.minGroupSize,
                                         advanceBookingLimit: defaultRestaurant.advanceBookingLimit,
                                         queueOpenTime: defaultRestaurant.queueOpenTime,
                                         queueCloseTime: defaultRestaurant.queueCloseTime,
                                         autoOpenTime: defaultRestaurant.autoOpenTime,
                                         autoCloseTime: defaultRestaurant.autoCloseTime)
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentContact_isEqual() {
        let otherRestaurant = Restaurant(uid: defaultRestaurant.uid,
                                         name: defaultRestaurant.name,
                                         email: defaultRestaurant.email,
                                         contact: "92736537",
                                         address: defaultRestaurant.address,
                                         menu: defaultRestaurant.menu,
                                         maxGroupSize: defaultRestaurant.maxGroupSize,
                                         minGroupSize: defaultRestaurant.minGroupSize,
                                         advanceBookingLimit: defaultRestaurant.advanceBookingLimit,
                                         queueOpenTime: defaultRestaurant.queueOpenTime,
                                         queueCloseTime: defaultRestaurant.queueCloseTime,
                                         autoOpenTime: defaultRestaurant.autoOpenTime,
                                         autoCloseTime: defaultRestaurant.autoCloseTime)
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentAddress_isEqual() {
        let otherRestaurant = Restaurant(uid: defaultRestaurant.uid,
                                         name: defaultRestaurant.name,
                                         email: defaultRestaurant.email,
                                         contact: defaultRestaurant.contact,
                                         address: "21 Jurong East",
                                         menu: defaultRestaurant.menu,
                                         maxGroupSize: defaultRestaurant.maxGroupSize,
                                         minGroupSize: defaultRestaurant.minGroupSize,
                                         advanceBookingLimit: defaultRestaurant.advanceBookingLimit,
                                         queueOpenTime: defaultRestaurant.queueOpenTime,
                                         queueCloseTime: defaultRestaurant.queueCloseTime,
                                         autoOpenTime: defaultRestaurant.autoOpenTime,
                                         autoCloseTime: defaultRestaurant.autoCloseTime)
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentMenu_isEqual() {
        let otherRestaurant = Restaurant(uid: defaultRestaurant.uid,
                                         name: defaultRestaurant.name,
                                         email: defaultRestaurant.email,
                                         contact: defaultRestaurant.contact,
                                         address: defaultRestaurant.address,
                                         menu: "Spaghetti, carbonara, fusili",
                                         maxGroupSize: defaultRestaurant.maxGroupSize,
                                         minGroupSize: defaultRestaurant.minGroupSize,
                                         advanceBookingLimit: defaultRestaurant.advanceBookingLimit,
                                         queueOpenTime: defaultRestaurant.queueOpenTime,
                                         queueCloseTime: defaultRestaurant.queueCloseTime,
                                         autoOpenTime: defaultRestaurant.autoOpenTime,
                                         autoCloseTime: defaultRestaurant.autoCloseTime)
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentMaxGroupSize_isEqual() {
        let otherRestaurant = Restaurant(uid: defaultRestaurant.uid,
                                         name: defaultRestaurant.name,
                                         email: defaultRestaurant.email,
                                         contact: defaultRestaurant.contact,
                                         address: defaultRestaurant.address,
                                         menu: defaultRestaurant.menu,
                                         maxGroupSize: 4,
                                         minGroupSize: defaultRestaurant.minGroupSize,
                                         advanceBookingLimit: defaultRestaurant.advanceBookingLimit,
                                         queueOpenTime: defaultRestaurant.queueOpenTime,
                                         queueCloseTime: defaultRestaurant.queueCloseTime,
                                         autoOpenTime: defaultRestaurant.autoOpenTime,
                                         autoCloseTime: defaultRestaurant.autoCloseTime)
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentMinGroupSize_isEqual() {
        let otherRestaurant = Restaurant(uid: defaultRestaurant.uid,
                                         name: defaultRestaurant.name,
                                         email: defaultRestaurant.email,
                                         contact: defaultRestaurant.contact,
                                         address: defaultRestaurant.address,
                                         menu: defaultRestaurant.menu,
                                         maxGroupSize: defaultRestaurant.maxGroupSize,
                                         minGroupSize: defaultRestaurant.minGroupSize,
                                         advanceBookingLimit: defaultRestaurant.advanceBookingLimit,
                                         queueOpenTime: defaultRestaurant.queueOpenTime,
                                         queueCloseTime: defaultRestaurant.queueCloseTime,
                                         autoOpenTime: defaultRestaurant.autoOpenTime,
                                         autoCloseTime: defaultRestaurant.autoCloseTime)
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentAdvanceBookingLimit_isEqual() {
        let otherRestaurant = Restaurant(uid: defaultRestaurant.uid,
                                         name: defaultRestaurant.name,
                                         email: defaultRestaurant.email,
                                         contact: defaultRestaurant.contact,
                                         address: defaultRestaurant.address,
                                         menu: defaultRestaurant.menu,
                                         maxGroupSize: defaultRestaurant.maxGroupSize,
                                         minGroupSize: defaultRestaurant.minGroupSize,
                                         advanceBookingLimit: 1,
                                         queueOpenTime: defaultRestaurant.queueOpenTime,
                                         queueCloseTime: defaultRestaurant.queueCloseTime,
                                         autoOpenTime: defaultRestaurant.autoOpenTime,
                                         autoCloseTime: defaultRestaurant.autoCloseTime)
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentQueueOpenTime_isEqual() {
        let otherRestaurant = Restaurant(uid: defaultRestaurant.uid,
                                         name: defaultRestaurant.name,
                                         email: defaultRestaurant.email,
                                         contact: defaultRestaurant.contact,
                                         address: defaultRestaurant.address,
                                         menu: defaultRestaurant.menu,
                                         maxGroupSize: defaultRestaurant.maxGroupSize,
                                         minGroupSize: defaultRestaurant.minGroupSize,
                                         advanceBookingLimit: defaultRestaurant.advanceBookingLimit,
                                         queueOpenTime: Date(timeIntervalSinceReferenceDate: -123456789.0),
                                         queueCloseTime: defaultRestaurant.queueCloseTime,
                                         autoOpenTime: defaultRestaurant.autoOpenTime,
                                         autoCloseTime: defaultRestaurant.autoCloseTime)
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentQueueCloseTime_isEqual() {
        let otherRestaurant = Restaurant(uid: defaultRestaurant.uid,
                                         name: defaultRestaurant.name,
                                         email: defaultRestaurant.email,
                                         contact: defaultRestaurant.contact,
                                         address: defaultRestaurant.address,
                                         menu: defaultRestaurant.menu,
                                         maxGroupSize: defaultRestaurant.maxGroupSize,
                                         minGroupSize: defaultRestaurant.minGroupSize,
                                         advanceBookingLimit: defaultRestaurant.advanceBookingLimit,
                                         queueOpenTime: defaultRestaurant.queueOpenTime,
                                         queueCloseTime: Date(timeIntervalSinceReferenceDate: -123456789.0),
                                         autoOpenTime: defaultRestaurant.autoOpenTime,
                                         autoCloseTime: defaultRestaurant.autoCloseTime)
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentAutoOpenTime_isEqual() {
        let otherRestaurant = Restaurant(uid: defaultRestaurant.uid,
                                         name: defaultRestaurant.name,
                                         email: defaultRestaurant.email,
                                         contact: defaultRestaurant.contact,
                                         address: defaultRestaurant.address,
                                         menu: defaultRestaurant.menu,
                                         maxGroupSize: defaultRestaurant.maxGroupSize,
                                         minGroupSize: defaultRestaurant.minGroupSize,
                                         advanceBookingLimit: defaultRestaurant.advanceBookingLimit,
                                         queueOpenTime: defaultRestaurant.queueOpenTime,
                                         queueCloseTime: defaultRestaurant.queueCloseTime,
                                         autoOpenTime: TimeInterval(50),
                                         autoCloseTime: defaultRestaurant.autoCloseTime)
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentAutoCloseTime_isEqual() {
        let otherRestaurant = Restaurant(uid: defaultRestaurant.uid,
                                         name: defaultRestaurant.name,
                                         email: defaultRestaurant.email,
                                         contact: defaultRestaurant.contact,
                                         address: defaultRestaurant.address,
                                         menu: defaultRestaurant.menu,
                                         maxGroupSize: defaultRestaurant.maxGroupSize,
                                         minGroupSize: defaultRestaurant.minGroupSize,
                                         advanceBookingLimit: defaultRestaurant.advanceBookingLimit,
                                         queueOpenTime: defaultRestaurant.queueOpenTime,
                                         queueCloseTime: defaultRestaurant.queueCloseTime,
                                         autoOpenTime: defaultRestaurant.autoOpenTime,
                                         autoCloseTime: TimeInterval(50))
        XCTAssertEqual(otherRestaurant, restaurant)
    }
}

struct defaultRestaurant {
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
}
