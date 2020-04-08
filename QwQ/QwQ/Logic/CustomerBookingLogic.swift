import Foundation

protocol CustomerBookingLogic: BookingStorageSyncDelegate {

    // Storage
    var bookingStorage: CustomerBookingStorage { get set }

    // View Controllers
    var bookingDelegate: BookingDelegate? { get set }
    var activitiesDelegate: ActivitiesDelegate? { get set }

    func addBookRecord(to restaurant: Restaurant,
                       at time: Date,
                       with groupSize: Int,
                       babyChairQuantity: Int,
                       wheelchairFriendly: Bool) -> Bool

    func addBookRecords(to restaurants: [Restaurant],
                        at time: Date,
                        with groupSize: Int,
                        babyChairQuantity: Int,
                        wheelchairFriendly: Bool) -> Bool

    func editBookRecord(oldRecord: BookRecord,
                        at time: Date,
                        with groupSize: Int,
                        babyChairQuantity: Int,
                        wheelchairFriendly: Bool)

    func withdrawBookRecord(_ bookRecord: BookRecord)
}
