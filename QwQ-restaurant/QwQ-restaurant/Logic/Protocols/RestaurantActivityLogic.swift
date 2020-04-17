protocol RestaurantActivityLogic {

    // Models
    var currentRecords: [Record] { get }
    var waitingRecords: [Record] { get }
    var historyRecords: [Record] { get }
}
