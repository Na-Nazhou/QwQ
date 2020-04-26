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
    
    override func setUp() {
        super.setUp()
        restaurant = RestaurantBuilder().build()
    }
    
    func testInit() {
        XCTAssertEqual(restaurant.uid, "1")
        XCTAssertEqual(restaurant.name, "Hot tomato")
        XCTAssertEqual(restaurant.email, "hottomato@mail.com")
        XCTAssertEqual(restaurant.contact, "66156257")
        XCTAssertEqual(restaurant.address, "31 Jurong East")
        XCTAssertEqual(restaurant.menu, "Aglio olio student meal at $9!")
        XCTAssertEqual(restaurant.maxGroupSize, 5)
        XCTAssertEqual(restaurant.minGroupSize, 1)
        XCTAssertEqual(restaurant.advanceBookingLimit, 2)
        XCTAssertEqual(restaurant.queueOpenTime, Date(timeIntervalSinceReferenceDate: 12_345))
        XCTAssertEqual(restaurant.queueCloseTime, Date(timeIntervalSinceReferenceDate: 12_345))
        XCTAssertEqual(restaurant.advanceBookingLimit, 2)
        XCTAssertEqual(restaurant.autoOpenTime, TimeInterval(60))
        XCTAssertEqual(restaurant.autoCloseTime, TimeInterval(60))
    }
    
    func testEqual_sameId_isEqual() {
        let otherRestaurant = RestaurantBuilder().build()
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentId_isnotEqual() {
        let otherRestaurant = RestaurantBuilder().with(uid: "2").build()
        XCTAssertFalse(otherRestaurant == restaurant)
    }
    
    func testEqual_differentName_isEqual() {
        let otherRestaurant = RestaurantBuilder().with(name: "Saizerya").build()
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentEmail_isEqual() {
        let otherRestaurant = RestaurantBuilder().with(email: "saizerya@mail.com").build()
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentContact_isEqual() {
        let otherRestaurant = RestaurantBuilder().with(contact: "92736537").build()
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentAddress_isEqual() {
        let otherRestaurant = RestaurantBuilder().with(address: "21 Jurong East").build()
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentMenu_isEqual() {
        let otherRestaurant = RestaurantBuilder().with(menu: "Spaghetti, carbonara, fusili").build()
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentMaxGroupSize_isEqual() {
        let otherRestaurant = RestaurantBuilder().with(maxGroupSize: 4).build()
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentMinGroupSize_isEqual() {
        let otherRestaurant = RestaurantBuilder().with(minGroupSize: 2).build()
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentAdvanceBookingLimit_isEqual() {
        let otherRestaurant = RestaurantBuilder().with(advanceBookingLimit: 1).build()
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentQueueOpenTime_isEqual() {
        let otherRestaurant = RestaurantBuilder()
            .with(queueOpenTime: Date(timeIntervalSinceReferenceDate: -123_456_789.0))
            .build()
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentQueueCloseTime_isEqual() {
        let otherRestaurant = RestaurantBuilder()
            .with(queueCloseTime: Date(timeIntervalSinceReferenceDate: -123_456_789.0))
            .build()
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentAutoOpenTime_isEqual() {
        let otherRestaurant = RestaurantBuilder().with(autoOpenTime: TimeInterval(50)).build()
        XCTAssertEqual(otherRestaurant, restaurant)
    }
    
    func testEqual_differentAutoCloseTime_isEqual() {
        let otherRestaurant = RestaurantBuilder().with(autoCloseTime: TimeInterval(50)).build()
        XCTAssertEqual(otherRestaurant, restaurant)
    }
}
