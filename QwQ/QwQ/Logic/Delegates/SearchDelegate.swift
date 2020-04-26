/// Represents the protocol a presentation delegate of restaurant logic should conform to.
protocol SearchDelegate: AnyObject {

    /// Updates the presentation of the collection of restaurants.
    func didUpdateRestaurantCollection()

    /// Updates the presentation from updating the collection of queue records.
    func didUpdateQueueRecordCollection()
}
