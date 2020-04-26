/// Represents the protocol a presentation delegate of restaurant activities should conform to.
protocol ActivitiesDelegate: AnyObject {

    /// Updates the presentation for updated restaurant.
    func didUpdateRestaurant()

    /// Updates the presentation of the current list of records.
    func didUpdateCurrentList()
    /// Updates the presentation of the waiting list of records.
    func didUpdateWaitingList()
    /// Updates the presentation of the history list of records.
    func didUpdateHistoryList()
}
