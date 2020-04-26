/// Represents the protocol the presentation delegate of a record should conform to.
protocol RecordDelegate: AnyObject {

    /// Updates the presentation when a record is added.
    func didAddRecord()

    /// Updates the presentation when records are added.
    func didAddRecords(_ newRecords: [Record])

    /// Updates the presentation when the record is updated.
    func didUpdateRecord()

    /// Updates the presentation of record when withdrawn.
    func didWithdrawRecord()
}

/// Represents the protocol the presentation delegate of a queue record should conform to.
protocol QueueDelegate: RecordDelegate {

    /// Updates presentation of `restaurant` to show it is closed.
    func didFindRestaurantQueueClosed(for restaurant: Restaurant)

}

/// Represents the protocol the presentation delegate of a book record should conform to.
protocol BookingDelegate: RecordDelegate {

    /// Updates presentation to show that there is already an existing book record at `restaurant`.
    func didFindExistingRecord(at restaurant: Restaurant)

    /// Updates presentation to show that the advanced booking limit has exceeded at `restaurant`.
    func didExceedAdvanceBookingLimit(at restaurant: Restaurant)

    /// Updates presentation to show the operating hours has exceeded at `restaurant`.
    func didExceedOperatingHours(at restaurant: Restaurant) 
}
