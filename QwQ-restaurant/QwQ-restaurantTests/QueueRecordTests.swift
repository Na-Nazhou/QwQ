//
//  QueueRecordTests.swift
//  QwQ-restaurantTests
//
//  Created by Tan Su Yee on 19/4/20.
//

import XCTest
@testable import QwQ_restaurant

class QueueRecordTests: XCTestCase {
    var queueRecord: QueueRecord!
    var queueRecordFromDictionary: QueueRecord?
    let customer = QueueRecordBuilder().customer
    let restaurant = QueueRecordBuilder().restaurant
    let id = QueueRecordBuilder().id
    let dictionary = [
        Constants.groupSizeKey: QueueRecordBuilder().groupSize,
        Constants.babyChairQuantityKey: QueueRecordBuilder().babyChairQuantity,
        Constants.wheelChairFriendlyKey: QueueRecordBuilder().wheelchairFriendly,
        Constants.startTimeKey: QueueRecordBuilder().startTime,
        Constants.admitTimeKey: QueueRecordBuilder().admitTime as Any,
        Constants.serveTimeKey: QueueRecordBuilder().serveTime as Any,
        Constants.rejectTimeKey: QueueRecordBuilder().rejectTime as Any,
        Constants.withdrawTimeKey: QueueRecordBuilder().withdrawTime as Any,
        Constants.estimatedAdmitTimeKey: QueueRecordBuilder().estimatedAdmitTime as Any,
        Constants.confirmAdmissionTimeKey: QueueRecordBuilder().confirmAdmissionTime as Any
        ] as [String: Any]
    
    override func setUp() {
        super.setUp()
        queueRecord = QueueRecordBuilder().build()
        queueRecordFromDictionary = QueueRecord(dictionary: QueueRecordBuilder().getDictionary(),
                                                customer: customer,
                                                restaurant: restaurant,
                                                id: id)
    }
    
    func testInit() {
        let otherQueueRecord = QueueRecord(id: "1",
                                           restaurant: RestaurantBuilder().build(),
                                           customer: CustomerBuilder().build(),
                                           groupSize: 2,
                                           babyChairQuantity: 0,
                                           wheelchairFriendly: false,
                                           startTime: Date())
        XCTAssertEqual(queueRecord, otherQueueRecord)
    }
    
//    func testDictionaryInit() {
//        XCTAssertEqual(queueRecordFromDictionary, queueRecord)
//    }
    
    func testEqual_sameId_isEqual() {
        let otherQueueRecord = QueueRecordBuilder().build()
        XCTAssertEqual(otherQueueRecord, queueRecord)
    }
    
    func testEqual_sameAttributes_isEqual() {
        let otherQueueRecord = QueueRecordBuilder().build()
        XCTAssertEqual(otherQueueRecord, queueRecord)
        XCTAssertTrue(queueRecord.completelyIdentical(to: otherQueueRecord))
    }
    
    func testEqual_differentId_isNotEqual() {
        let otherQueueRecord = QueueRecordBuilder().with(id: "2").build()
        XCTAssertFalse(otherQueueRecord == queueRecord)
    }
    
    func testEqual_differentGroupSize_isEqual() {
        let otherQueueRecord = QueueRecordBuilder()
            .with(groupSize: 3)
            .build()
        XCTAssertTrue(otherQueueRecord == queueRecord)
    }
    
    func testEqual_differentBabyChairQuantity_isEqual() {
        let otherQueueRecord = QueueRecordBuilder()
            .with(babyChairQuantity: 3)
            .build()
        XCTAssertTrue(otherQueueRecord == queueRecord)
    }
    
    func testEqual_differentWheelchairFriendly_isEqual() {
        let otherQueueRecord = QueueRecordBuilder()
            .with(wheelchairFriendly: false)
            .build()
        XCTAssertTrue(otherQueueRecord == queueRecord)
    }
    
    func testEqual_differentAdmitTime_isEqual() {
        let otherQueueRecord = QueueRecordBuilder()
            .with(admitTime: Date(timeIntervalSinceReferenceDate: 12_345))
            .build()
        XCTAssertTrue(otherQueueRecord == queueRecord)
    }
    
    func testEqual_differentServeTime_isEqual() {
        let otherQueueRecord = QueueRecordBuilder()
            .with(serveTime: Date(timeIntervalSinceReferenceDate: 12_345))
            .build()
        XCTAssertTrue(otherQueueRecord == queueRecord)
    }
    
    func testEqual_differentRejectTime_isEqual() {
        let otherQueueRecord = QueueRecordBuilder()
            .with(rejectTime: Date(timeIntervalSinceReferenceDate: 12_345))
            .build()
        XCTAssertTrue(otherQueueRecord == queueRecord)
    }
    
    func testEqual_differentWithdrawTime_isEqual() {
        let otherQueueRecord = QueueRecordBuilder()
            .with(withdrawTime: Date(timeIntervalSinceReferenceDate: 12_345))
            .build()
        XCTAssertTrue(otherQueueRecord == queueRecord)
    }
    
    func testEqual_differentEstimatedAdmitTime_isEqual() {
        let otherQueueRecord = QueueRecordBuilder()
            .with(estimatedAdmitTime: Date(timeIntervalSinceReferenceDate: 12_345))
            .build()
        XCTAssertTrue(otherQueueRecord == queueRecord)
    }
    
    func testEqual_differentConfirmAdmissionTime_isEqual() {
        let otherQueueRecord = QueueRecordBuilder()
            .with(confirmAdmissionTime: Date(timeIntervalSinceReferenceDate: 12_345))
            .build()
        XCTAssertTrue(otherQueueRecord == queueRecord)
    }
}
