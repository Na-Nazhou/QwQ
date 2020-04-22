import Foundation

protocol CustomerBookingLogic: BookingStorageSyncDelegate {

    // View Controllers
    var bookingDelegate: BookingDelegate? { get set }
    var activitiesDelegate: ActivitiesDelegate? { get set }

    func addBookRecords(to restaurants: [Restaurant],
                        at time: Date,
                        with groupSize: Int,
                        babyChairQuantity: Int,
                        wheelchairFriendly: Bool) -> Bool

    func editBookRecord(oldRecord: BookRecord,
                        at time: Date,
                        with groupSize: Int,
                        babyChairQuantity: Int,
                        wheelchairFriendly: Bool) -> Bool

    func withdrawBookRecord(_ bookRecord: BookRecord)
}
