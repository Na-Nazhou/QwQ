/// Represents the protocol a customer activity logic handler should conform to.
protocol CustomerActivityLogic {

    var activeRecords: [Record] { get }
    var historyRecords: [Record] { get }
    var missedRecords: [Record] { get }
}
