//
//  BookRecordTests.swift
//  QwQTests
//
//  Created by Tan Su Yee on 18/4/20.
//

import XCTest
@testable import QwQ

class BookRecordTests: XCTestCase {
    var bookRecord: BookRecord!
    var bookRecordFromDictionary: BookRecord?
    let customer = BookRecordBuilder().customer
    let restaurant = BookRecordBuilder().restaurant
    let id = BookRecordBuilder().id
    let dictionary = [
        Constants.groupSizeKey: BookRecordBuilder().groupSize,
        Constants.babyChairQuantityKey: BookRecordBuilder().babyChairQuantity,
        Constants.wheelChairFriendlyKey: BookRecordBuilder().wheelchairFriendly,
        Constants.timeKey: BookRecordBuilder().time,
        Constants.admitTimeKey: BookRecordBuilder().admitTime as Any,
        Constants.serveTimeKey: BookRecordBuilder().serveTime as Any,
        Constants.rejectTimeKey: BookRecordBuilder().rejectTime as Any,
        Constants.withdrawTimeKey: BookRecordBuilder().withdrawTime as Any
        ] as [String: Any]
    
    override func setUp() {
        super.setUp()
        bookRecord = BookRecordBuilder().build()
        bookRecordFromDictionary = BookRecord(dictionary: BookRecordBuilder().getDictionary(),
                                              customer: customer,
                                              restaurant: restaurant,
                                              id: id)
    }
    
    func testInit() {
        let otherBookRecord = BookRecord(id: "1",
                                         restaurant: RestaurantBuilder().build(),
                                         customer: CustomerBuilder().build(),
                                         time: Date(),
                                         groupSize: 2,
                                         babyChairQuantity: 0,
                                         wheelchairFriendly: false,
                                         admitTime: Date(),
                                         serveTime: Date(),
                                         rejectTime: Date(),
                                         withdrawTime: Date())
        XCTAssertEqual(bookRecord, otherBookRecord)
    }
    
//    func testDictionaryInit() {
//        XCTAssertEqual(bookRecordFromDictionary, bookRecord)
//    }
    
    func testEqual_sameId_isEqual() {
        let otherBookRecord = BookRecordBuilder().build()
        XCTAssertEqual(otherBookRecord, bookRecord)
    }
    
    func testEqual_sameAttributes_isEqual() {
        let otherBookRecord = BookRecordBuilder().build()
        XCTAssertEqual(otherBookRecord, bookRecord)
        XCTAssertTrue(bookRecord.completelyIdentical(to: otherBookRecord))
    }
    
    func testEqual_differentId_isNotEqual() {
        let otherBookRecord = BookRecordBuilder().with(id: "2").build()
        XCTAssertFalse(otherBookRecord == bookRecord)
    }
    
    func testEqual_differentGroupSize_isEqual() {
        let otherBookRecord = BookRecordBuilder()
            .with(groupSize: 3)
            .build()
        XCTAssertTrue(otherBookRecord == bookRecord)
    }
    
    func testEqual_differentBabyChairQuantity_isEqual() {
        let otherBookRecord = BookRecordBuilder()
            .with(babyChairQuantity: 3)
            .build()
        XCTAssertTrue(otherBookRecord == bookRecord)
    }
    
    func testEqual_differentWheelchairFriendly_isEqual() {
        let otherBookRecord = BookRecordBuilder()
            .with(wheelchairFriendly: false)
            .build()
        XCTAssertTrue(otherBookRecord == bookRecord)
    }
    
    func testEqual_differentAdmitTime_isEqual() {
        let otherBookRecord = BookRecordBuilder()
            .with(admitTime: Date(timeIntervalSinceReferenceDate: 12_345))
            .build()
        XCTAssertTrue(otherBookRecord == bookRecord)
    }
    
    func testEqual_differentServeTime_isEqual() {
        let otherBookRecord = BookRecordBuilder()
            .with(serveTime: Date(timeIntervalSinceReferenceDate: 12_345))
            .build()
        XCTAssertTrue(otherBookRecord == bookRecord)
    }
    
    func testEqual_differentRejectTime_isEqual() {
        let otherBookRecord = BookRecordBuilder()
            .with(rejectTime: Date(timeIntervalSinceReferenceDate: 12_345))
            .build()
        XCTAssertTrue(otherBookRecord == bookRecord)
    }
    
    func testEqual_differentWithdrawTime_isEqual() {
        let otherBookRecord = BookRecordBuilder()
            .with(withdrawTime: Date(timeIntervalSinceReferenceDate: 12_345))
            .build()
        XCTAssertTrue(otherBookRecord == bookRecord)
    }
    
    func testEqual_differentTime_isEqual() {
        let otherBookRecord = BookRecordBuilder()
            .with(time: Date(timeIntervalSinceReferenceDate: 12_345))
            .build()
        XCTAssertTrue(otherBookRecord == bookRecord)
    }
}
