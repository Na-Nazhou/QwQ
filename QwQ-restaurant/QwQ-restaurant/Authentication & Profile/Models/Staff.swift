/// A restaurant staff, which is identified by his `uid` for equality and hash.
struct Staff: User {
    let uid: String
    let name: String
    let email: String
    let contact: String

    let assignedRestaurant: String?
    let roleName: String?

    init(uid: String, name: String, email: String, contact: String,
         assignedRestaurant: String? = nil, roleName: String? = nil) {
        self.uid = uid
        self.name = name
        self.email = email
        self.contact = contact
        self.assignedRestaurant = assignedRestaurant
        self.roleName = roleName
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
