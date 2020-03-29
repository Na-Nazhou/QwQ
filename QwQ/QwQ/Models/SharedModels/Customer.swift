//
//  Customer.swift
//  QwQ
//
//  Created by Nazhou Na on 11/3/20.
//  Copyright © 2020 Appfish. All rights reserved.
//

struct Customer: User {
    let uid: String
    let name: String
    let email: String
    let contact: String

    var dictionary: [String: Any] {
        [
            Constants.uidKey: uid,
            Constants.nameKey: name,
            Constants.emailKey: email,
            Constants.contactKey: contact
        ]
    }

    init(uid: String, name: String, email: String, contact: String) {
        self.uid = uid
        self.name = name
        self.email = email
        self.contact = contact
    }

    init?(dictionary: [String: Any]) {
        guard let uid = dictionary[Constants.uidKey] as? String,
            let name = dictionary[Constants.nameKey] as? String,
            let email = dictionary[Constants.emailKey] as? String,
            let contact = dictionary[Constants.contactKey] as? String else {
                return nil
        }

        self.init(uid: uid, name: name, email: email, contact: contact)
    }
}

extension Customer {
    static func == (lhs: Customer, rhs: Customer) -> Bool {
        lhs.uid == rhs.uid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.uid)
    }
}
