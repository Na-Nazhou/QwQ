/// Rerpesents the protocol a logic handler of restaurant activity should conform to.
protocol RestaurantActivityLogic {
    // MARK: Models in restaurant activity
    var currentRecords: [Record] { get }
    var waitingRecords: [Record] { get }
    var historyRecords: [Record] { get }
}
