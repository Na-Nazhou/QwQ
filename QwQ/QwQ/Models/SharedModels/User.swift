protocol User: Hashable, Codable {
    var uid: String { get }
    var name: String { get }
    var email: String { get }
    var contact: String { get }
}
