//
//  Staff.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 4/4/20.
//

struct Staff: User {
    let uid: String
    let name: String
    let email: String
    let contact: String

    let restaurantWorkingFor: String
    let permissions: [Permissions]

    var dictionary: [String: Any] {
        [
            Constants.uidKey: uid,
            Constants.nameKey: name,
            Constants.emailKey: email,
            Constants.contactKey: contact,
            Constants.restaurantWorkingForKey: restaurantWorkingFor,
            Constants.permissionsKey: permissions
        ]
    }

    init(uid: String, name: String, email: String, contact: String, restaurantWorkingFor: String, permissions: [Permissions]) {
        self.uid = uid
        self.name = name
        self.email = email
        self.contact = contact
        self.restaurantWorkingFor = restaurantWorkingFor
        self.permissions = permissions
    }

    init?(dictionary: [String: Any]) {
        guard let uid = dictionary[Constants.uidKey] as? String,
            let name = dictionary[Constants.nameKey] as? String,
            let email = dictionary[Constants.emailKey] as? String,
            let contact = dictionary[Constants.contactKey] as? String,
            let restaurantWorkingFor = dictionary[Constants.restaurantWorkingForKey] as? String,
            let permissions = dictionary[Constants.permissionsKey] as? [Permissions] else {
                return nil
        }

        self.init(uid: uid,
                  name: name,
                  email: email,
                  contact: contact,
                  restaurantWorkingFor: restaurantWorkingFor,
                  permissions: permissions)
    }
}

extension Staff {
    static func == (lhs: Staff, rhs: Staff) -> Bool {
        lhs.uid == rhs.uid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.uid)
    }
}
