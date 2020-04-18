//
//  CustomerTests.swift
//  QwQTests
//
//  Created by Tan Su Yee on 18/4/20.
//

import XCTest
@testable import QwQ

class CustomerTests: XCTestCase {
    var customer: Customer!
    var customerFromDictionary: Customer?
    let dictionary = [
        Constants.uidKey: defaultCustomer.uid,
        Constants.nameKey: defaultCustomer.name,
        Constants.emailKey: defaultCustomer.email,
        Constants.contactKey: defaultCustomer.contact
    ]
    
    override func setUp() {
        super.setUp()
        customer = Customer(uid: defaultCustomer.uid,
                            name: defaultCustomer.name,
                            email: defaultCustomer.email,
                            contact: defaultCustomer.contact)
        customerFromDictionary = Customer(dictionary: dictionary)
    }
    
    func testInit() {
        XCTAssertEqual(customer.uid, defaultCustomer.uid)
        XCTAssertEqual(customer.name, defaultCustomer.name)
        XCTAssertEqual(customer.email, defaultCustomer.email)
        XCTAssertEqual(customer.contact, defaultCustomer.contact)
    }
    
    func testDictionaryInit() {
        XCTAssertEqual(customerFromDictionary, customer)
    }
    
    func testEqual_sameId_isEqual() {
        let otherCustomer = Customer(uid: defaultCustomer.uid,
                                     name: defaultCustomer.name,
                                     email: defaultCustomer.email,
                                     contact: defaultCustomer.contact)
        XCTAssertEqual(otherCustomer, customer)
    }
    
    func testEqual_differentId_isnotEqual() {
        let otherCustomer = Customer(uid: "2",
                                     name: defaultCustomer.name,
                                     email: defaultCustomer.email,
                                     contact: defaultCustomer.contact)
        XCTAssertFalse(otherCustomer == customer)
    }
    
    func testEqual_differentName_isEqual() {
        let otherCustomer = Customer(uid: defaultCustomer.uid,
                                     name: "Eli",
                                     email: defaultCustomer.email,
                                     contact: defaultCustomer.contact)
        XCTAssertEqual(otherCustomer, customer)
    }
    
    func testEqual_differentEmail_isnotEqual() {
        let otherCustomer = Customer(uid: defaultCustomer.uid,
                                     name: defaultCustomer.name,
                                     email: "john1@mail.com",
                                     contact: defaultCustomer.contact)
        XCTAssertEqual(otherCustomer, customer)
    }
    
    func testEqual_differentContact_isnotEqual() {
        let otherCustomer = Customer(uid: defaultCustomer.uid,
                                     name: defaultCustomer.name,
                                     email: defaultCustomer.email,
                                     contact: "82273833")
        XCTAssertEqual(otherCustomer, customer)
    }
}

struct defaultCustomer {
    static let uid = "1"
    static let name = "John"
    static let email = "john@mail.com"
    static let contact = "92736282"
}
