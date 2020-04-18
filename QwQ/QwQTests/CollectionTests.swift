//
//  CollectionTests.swift
//  QwQTests
//
//  Created by Tan Su Yee on 18/4/20.
//

import XCTest
@testable import QwQ

class CollectionTests: XCTestCase {
    var collection: Collection<Restaurant>!
    
    override func setUp() {
        super.setUp()
        collection = Collection()
    }

    func testAdd_newElement_returnsTrue() {
        XCTAssertEqual(collection.size, 0)
        
        let restaurant = RestaurantBuilder.build()
        XCTAssertTrue(collection.add(restaurant))
        
        XCTAssertEqual(collection.size, 1)
        XCTAssertEqual(collection.elements.first, restaurant)
    }
    
    func testAdd_existingElement_returnsFalse() {
        XCTAssertEqual(collection.size, 0)
        
        collection.add(RestaurantBuilder.build())
        XCTAssertEqual(collection.size, 1)
        
        XCTAssertFalse(collection.add(RestaurantBuilder.build()))
        XCTAssertEqual(collection.size, 1)
    }
    
    func testAddMultiple_newElements_returnsTrue() {
        let restaurants = [RestaurantBuilder.build(), RestaurantBuilder.with(uid: "2")]
        let set = Set(restaurants)
        
        XCTAssertEqual(collection.size, 0)
        
        collection.add(restaurants)
        
        XCTAssertEqual(collection.size, 2)
        XCTAssertEqual(collection.elements, set)
    }
    
    func testAddMultiple_existingElements_returnsFalse() {
        let restaurants = [RestaurantBuilder.build(), RestaurantBuilder.with(uid: "2")]
        let set = Set(restaurants)
        
        collection.add(restaurants)
        XCTAssertEqual(collection.size, 2)
        
        collection.add(restaurants)
        XCTAssertEqual(collection.size, 2)
        XCTAssertEqual(collection.elements, set)
    }
    
    func testUpdate_existingElement_returnsTrue() {
        XCTAssertEqual(collection.size, 0)
        
        XCTAssertTrue(collection.add(RestaurantBuilder.build()))
        XCTAssertEqual(collection.size, 1)
        
        let updatedRestaurant = RestaurantBuilder.with(name: "Eli")
        XCTAssertTrue(collection.update(updatedRestaurant))
        XCTAssertEqual(collection.size, 1)
        XCTAssertEqual(collection.elements.first, updatedRestaurant)
    }
    
    func testUpdate_noExistingElement_returnsFalse() {
        XCTAssertEqual(collection.size, 0)
        
        let updatedRestaurant = RestaurantBuilder.with(name: "Eli")
        XCTAssertFalse(collection.update(updatedRestaurant))
        XCTAssertEqual(collection.size, 0)
    }
    
    func testRemove_existingElement_returnsTrue() {
        XCTAssertEqual(collection.size, 0)
        
        let restaurant = RestaurantBuilder.build()
        XCTAssertTrue(collection.add(restaurant))
        XCTAssertEqual(collection.size, 1)
        
        XCTAssertTrue(collection.remove(restaurant))
        XCTAssertEqual(collection.size, 0)
    }
    
    func testRemove_noExistingElement_returnsFalse() {
        XCTAssertEqual(collection.size, 0)
        
        let restaurant = RestaurantBuilder.build()
        XCTAssertFalse(collection.remove(restaurant))
        XCTAssertEqual(collection.size, 0)
    }
    
    func testReset() {
        let restaurants = [RestaurantBuilder.build(), RestaurantBuilder.with(uid: "2")]
        collection.add(restaurants)
        XCTAssertEqual(collection.size, 2)
        
        collection.reset()
        XCTAssertEqual(collection.size, 0)
    }
}
