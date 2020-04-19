//
//  CustomerBuilder.swift
//  QwQ-restaurantTests
//
//  Created by Tan Su Yee on 19/4/20.
//

import Foundation
@testable import QwQ_restaurant

class CustomerBuilder {
    var uid = "1"
    var name = "John"
    var email = "john@mail.com"
    var contact = "92736282"
    
    init() {
    }
    
    init(uid: String, name: String, email: String, contact: String) {
        self.uid = uid
        self.name = name
        self.email = email
        self.contact = contact
    }
    
    func getDictionary() -> [String: Any] {
        return [
            Constants.uidKey: uid,
            Constants.nameKey: name,
            Constants.emailKey: email,
            Constants.contactKey: contact,
            ] as [String : Any]
    }
    
    func with(uid: String) -> CustomerBuilder {
        self.uid = uid
        return self
    }
    
    func with(name: String) -> CustomerBuilder {
        self.name = name
        return self
    }
    
    func with(email: String) -> CustomerBuilder {
        self.email = email
        return self
    }
    
    func with(contact: String) -> CustomerBuilder {
        self.contact = contact
        return self
    }
    
    func build() -> Customer {
        return Customer(uid: uid,
                        name: name,
                        email: email,
                        contact: contact)
    }
}
