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

    let assignedRestaurant: String?
    let roleName: String?

    var dictionary: [String: Any] {
        var data = [String: Any]()

        data[Constants.uidKey] = uid
        data[Constants.nameKey] = name
        data[Constants.emailKey] = email
        data[Constants.contactKey] = contact

        if let assignedRestaurant = assignedRestaurant {
            data[Constants.assignedRestaurantKey] = assignedRestaurant
        }
        if let roleName = roleName {
            data[Constants.roleNameKey] = roleName
        }

        return data
    }

    init(uid: String, name: String, email: String, contact: String,
         assignedRestaurant: String?, roleName: String?) {
        self.uid = uid
        self.name = name
        self.email = email
        self.contact = contact
        self.assignedRestaurant = assignedRestaurant
        self.roleName = roleName
    }

    init?(dictionary: [String: Any]) {

        guard let uid = dictionary[Constants.uidKey] as? String,
            let name = dictionary[Constants.nameKey] as? String,
            let email = dictionary[Constants.emailKey] as? String,
            let contact = dictionary[Constants.contactKey] as? String else {
                return nil
        }

        let assignedRestaurant = dictionary[Constants.assignedRestaurantKey] as? String
        let roleName = dictionary[Constants.roleNameKey] as? String

        self.init(uid: uid,
                  name: name,
                  email: email,
                  contact: contact,
                  assignedRestaurant: assignedRestaurant,
                  roleName: roleName)
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
