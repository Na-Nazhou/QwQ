import Foundation

/// Represents the protocol a customer booking logic handler should conform to.
protocol CustomerBookingLogic: BookingStorageSyncDelegate {

    // View Controllers
    /// Presentation delegate of book record.
    var bookingDelegate: BookingDelegate? { get set }
    /// Presentation delegate of book activities.
    var activitiesDelegate: ActivitiesDelegate? { get set }
    
    /// Adds bookings for the customer at `restaurants` with the specified attendee details.
    func addBookRecords(to restaurants: [Restaurant],
                        at time: Date,
                        with groupSize: Int,
                        babyChairQuantity: Int,
                        wheelchairFriendly: Bool) -> Bool
    
    /// Edits `oldRecord` with the specified attendee details.
    func editBookRecord(oldRecord: BookRecord,
                        at time: Date,
                        with groupSize: Int,
                        babyChairQuantity: Int,
                        wheelchairFriendly: Bool) -> Bool
    
    /// Withdraws `bookRecord`
    func withdrawBookRecord(_ bookRecord: BookRecord)
}
