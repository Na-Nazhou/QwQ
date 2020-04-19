//
//  CustomerTests.swift
//  QwQ-restaurantTests
//
//  Created by Tan Su Yee on 19/4/20.
//

import XCTest
@testable import QwQ_restaurant

class CustomerTests: XCTestCase {
    var customer: Customer!
    var customerFromDictionary: Customer?
    let dictionary = [
        Constants.uidKey: CustomerBuilder().uid,
        Constants.nameKey: CustomerBuilder().name,
        Constants.emailKey: CustomerBuilder().email,
        Constants.contactKey: CustomerBuilder().contact
    ]
    
    override func setUp() {
        super.setUp()
        customer = CustomerBuilder().build()
        customerFromDictionary = Customer(dictionary: dictionary)
    }
    
    func testInit() {
        XCTAssertEqual(customer.uid, "1")
        XCTAssertEqual(customer.name, "John")
        XCTAssertEqual(customer.email, "john@mail.com")
        XCTAssertEqual(customer.contact, CustomerBuilder().contact)
    }
    
    func testDictionaryInit() {
        XCTAssertEqual(customerFromDictionary, customer)
    }
    
    func testEqual_sameId_isEqual() {
        let otherCustomer = CustomerBuilder().build()
        XCTAssertEqual(otherCustomer, customer)
    }
    
    func testEqual_differentId_isnotEqual() {
        let otherCustomer = CustomerBuilder().with(uid: "2").build()
        XCTAssertFalse(otherCustomer == customer)
    }
    
    func testEqual_differentName_isEqual() {
        let otherCustomer = CustomerBuilder().with(name: "Eli").build()
        XCTAssertEqual(otherCustomer, customer)
    }
    
    func testEqual_differentEmail_isnotEqual() {
        let otherCustomer = CustomerBuilder().with(email: "eli@mail.com").build()
        XCTAssertEqual(otherCustomer, customer)
    }
    
    func testEqual_differentContact_isnotEqual() {
        let otherCustomer = CustomerBuilder().with(contact: "98735748").build()
        XCTAssertEqual(otherCustomer, customer)
    }
}
