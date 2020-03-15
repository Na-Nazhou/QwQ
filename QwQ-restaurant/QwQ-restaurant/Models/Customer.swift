//
//  Customer.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 15/3/20.
//

struct Customer: User {
    let uid: String
    let name: String
    let email: String
    let contact: String

    var dictionary: [String: Any] {
        return [
            "uid": uid,
            "name": name,
            "email": email,
            "contact": contact,
        ]
    }

    init(uid: String, name: String, email: String, contact: String) {
        self.uid = uid
        self.name = name
        self.email = email
        self.contact = contact
    }

    init?(dictionary: [String: Any]) {
        guard let uid = dictionary["uid"] as? String,
            let name = dictionary["name"] as? String,
            let email = dictionary["email"] as? String,
            let contact = dictionary["contact"] as? String else {
                return nil
        }

        self.uid = uid
        self.name = name
        self.email = email
        self.contact = contact
    }
}
