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

    let assignedRestaurant: String
    let isOwner: Bool
    let permissions: [Permissions]

    var dictionary: [String: Any] {
        [
            Constants.uidKey: uid,
            Constants.nameKey: name,
            Constants.emailKey: email,
            Constants.contactKey: contact,
            Constants.assignedRestaurantKey: assignedRestaurant,
            Constants.permissionsKey: permissions
        ]
    }

    init(uid: String, name: String, email: String, contact: String,
         assignedRestaurant: String, isOwner: Bool, permissions: [Permissions]) {
        self.uid = uid
        self.name = name
        self.email = email
        self.contact = contact
        self.assignedRestaurant = assignedRestaurant
        self.isOwner = isOwner
        self.permissions = permissions
    }

    init?(dictionary: [String: Any]) {
        guard let uid = dictionary[Constants.uidKey] as? String,
            let name = dictionary[Constants.nameKey] as? String,
            let email = dictionary[Constants.emailKey] as? String,
            let contact = dictionary[Constants.contactKey] as? String,
            let assignedRestaurant = dictionary[Constants.assignedRestaurantKey] as? String,
            let isOwner = dictionary[Constants.isOwnerKey] as? Bool,
            let permissions = dictionary[Constants.permissionsKey] as? [Permissions] else {
                return nil
        }

        self.init(uid: uid,
                  name: name,
                  email: email,
                  contact: contact,
                  assignedRestaurant: assignedRestaurant,
                  isOwner: isOwner,
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
