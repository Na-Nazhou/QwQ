/// A customer, which is identified by his `uid` for equality and hash.
struct Customer: User {
    let uid: String
    let name: String
    let email: String
    let contact: String
    
}

extension Customer {
    static func == (lhs: Customer, rhs: Customer) -> Bool {
        lhs.uid == rhs.uid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.uid)
    }
}
