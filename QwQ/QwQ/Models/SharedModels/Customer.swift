/// A customer, which is identified by his `uid` for equality and hash.
struct Customer: User {
    let uid: String
    let name: String
    let email: String
    let contact: String

    init(uid: String, name: String, email: String, contact: String) {
        self.uid = uid
        self.name = name
        self.email = email
        self.contact = contact
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
