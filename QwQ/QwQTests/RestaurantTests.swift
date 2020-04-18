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
        Constants.uidKey: RestaurantBuilder.uid,
        Constants.nameKey: RestaurantBuilder.name,
        Constants.emailKey: RestaurantBuilder.email,
        Constants.contactKey: RestaurantBuilder.contact,
        Constants.addressKey: RestaurantBuilder.address,
        Constants.menuKey: RestaurantBuilder.menu,
        Constants.maxGroupSizeKey: RestaurantBuilder.maxGroupSize,
        Constants.minGroupSizeKey: RestaurantBuilder.minGroupSize,
        Constants.advanceBookingLimitKey: RestaurantBuilder.advanceBookingLimit,
        Constants.queueOpenTimeKey: RestaurantBuilder.queueOpenTime,
        Constants.queueCloseTimeKey: RestaurantBuilder.queueCloseTime,
        Constants.autoOpenTimeKey: RestaurantBuilder.autoOpenTime,
        Constants.autoCloseTimeKey: RestaurantBuilder.autoCloseTime
        ] as [String : Any]
    
    override func setUp() {
        super.setUp()
        restaurant = RestaurantBuilder.build()
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
        let otherRestaurant = RestaurantBuilder.build()
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentId_isnotEqual() {
        let otherRestaurant = RestaurantBuilder.with(uid: "2")
        XCTAssertFalse(otherRestaurant == restaurant)
    }
    
    func testEqual_differentName_isEqual() {
        let otherRestaurant = RestaurantBuilder.with(name: "Saizerya")
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentEmail_isEqual() {
        let otherRestaurant = RestaurantBuilder.with(email: "saizerya@mail.com")
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentContact_isEqual() {
        let otherRestaurant = RestaurantBuilder.with(contact: "92736537")
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentAddress_isEqual() {
        let otherRestaurant = RestaurantBuilder.with(address: "21 Jurong East")
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentMenu_isEqual() {
        let otherRestaurant = RestaurantBuilder.with(menu: "Spaghetti, carbonara, fusili")
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentMaxGroupSize_isEqual() {
        let otherRestaurant = RestaurantBuilder.with(maxGroupSize: 4)
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentMinGroupSize_isEqual() {
        let otherRestaurant = RestaurantBuilder.with(minGroupSize: 2)
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentAdvanceBookingLimit_isEqual() {
        let otherRestaurant = RestaurantBuilder.with(advanceBookingLimit: 1)
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentQueueOpenTime_isEqual() {
        let otherRestaurant = RestaurantBuilder.with(queueOpenTime: Date(timeIntervalSinceReferenceDate: -123456789.0))
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentQueueCloseTime_isEqual() {
        let otherRestaurant = RestaurantBuilder.with(queueCloseTime: Date(timeIntervalSinceReferenceDate: -123456789.0))
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentAutoOpenTime_isEqual() {
        let otherRestaurant = RestaurantBuilder.with(autoOpenTime: TimeInterval(50))
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentAutoCloseTime_isEqual() {
        let otherRestaurant = RestaurantBuilder.with(autoCloseTime: TimeInterval(50))
        XCTAssertEqual(otherRestaurant, restaurant)
    }
}
