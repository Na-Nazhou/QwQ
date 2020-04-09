import FirebaseFirestore
import os.log

// note that stats is considered static (history stats)
class FIRStatsStorage: RestaurantStatsStorage {
    static let shared = FIRStatsStorage()

    private let db = Firestore.firestore()
    private var queuesDb: CollectionReference {
        db.collection(Constants.queuesDirectory)
    }
    private var bookingDb: CollectionReference {
        db.collection(Constants.bookingsDirectory)
    }

    private func restaurantQueues(of restaurant: Restaurant, from date: Date, to date2: Date) -> Query {
        queuesDb.whereField(Constants.restaurantKey, isEqualTo: restaurant.uid)
            .whereField(Constants.startTimeKey, isLessThanOrEqualTo: getEndOfDay(of: date2))
            .whereField(Constants.startTimeKey, isGreaterThanOrEqualTo: getStartOfDay(of: date))
    }

    private func restaurantBookings(of restaurant: Restaurant, from date: Date, to date2: Date) -> Query {
        bookingDb.whereField(Constants.restaurantKey, isEqualTo: restaurant.uid)
            .whereField(Constants.timeKey, isLessThanOrEqualTo: getEndOfDay(of: date2))
            .whereField(Constants.timeKey, isGreaterThanOrEqualTo: getStartOfDay(of: date))
    }

    func fetchTotalNumCustomers(for restaurant: Restaurant,
                                from date: Date, to date2: Date,
                                completion: @escaping (Int) -> Void) {
        checkFromToDates(from: date, to: date)

        restaurantQueues(of: restaurant, from: date, to: date2)
            .getDocuments { recordsSnapshot, err in
                if let err = err {
                    os_log("Error loading queue records from db.",
                           log: Log.queueRetrievalError,
                           type: .error,
                           err.localizedDescription)
                    return
                }
                //completion(recordsSnapshot!.count) //num of records or
                recordsSnapshot!.documents.forEach {
                    // num of ppl in the record
                    completion($0.data()[Constants.groupSizeKey] as? Int ?? 0)
                }
            }

       restaurantBookings(of: restaurant, from: date, to: date2)
            .getDocuments { recordsSnapshot, err in
                if let err = err {
                    os_log("Error loading book records from db.",
                           log: Log.bookRetrievalError,
                           type: .error,
                           err.localizedDescription)
                    return
                }
                recordsSnapshot!.documents.forEach {
                    completion($0.data()[Constants.groupSizeKey] as? Int ?? 0)
                }
            }
    }
    
    func fetchTotalWaitingTimeForCustomer(for restaurant: Restaurant,
                                          from date: Date, to date2: Date,
                                          completion: @escaping (Int) -> Void) {
        checkFromToDates(from: date, to: date)

        restaurantQueues(of: restaurant, from: date, to: date2)
            .getDocuments { recordsSnapshot, err in
                if let err = err {
                    os_log("Error loading queue records from db.",
                           log: Log.queueRetrievalError,
                           type: .error,
                           err.localizedDescription)
                    return
                }
                recordsSnapshot!.documents.forEach {
                    let dict = $0.data()
                    guard let startTime = (dict[Constants.startTimeKey] as? Timestamp)?.dateValue(),
                        let admitTime = (dict[Constants.admitTimeKey] as? Timestamp)?.dateValue() else {
                            return
                    }
                    completion(self.timeDifferenceInSeconds(between: startTime, and: admitTime))
                }
            }
    }

    func fetchTotalWaitingTimeForRestaurant(for restaurant: Restaurant,
                                            from date: Date, to date2: Date,
                                            completion: @escaping (Int) -> Void) {
        checkFromToDates(from: date, to: date)

        restaurantQueues(of: restaurant, from: date, to: date2)
            .getDocuments { recordsSnapshot, err in
                if let err = err {
                    os_log("Error loading queue records from db.",
                           log: Log.queueRetrievalError,
                           type: .error,
                           err.localizedDescription)
                    return
                }
                recordsSnapshot!.documents.forEach {
                    let dict = $0.data()
                    guard let serveTime = (dict[Constants.serveTimeKey] as? Timestamp)?.dateValue(),
                        let admitTime = (dict[Constants.admitTimeKey] as? Timestamp)?.dateValue() else {
                            return
                    }
                    completion(self.timeDifferenceInSeconds(between: admitTime, and: serveTime))
                }
            }
    }
    
    func fetchQueueCancellationRate(for restaurant: Restaurant,
                                    from date: Date, to date2: Date,
                                    completion: @escaping (Int) -> Void) {
        checkFromToDates(from: date, to: date)

        restaurantQueues(of: restaurant, from: date, to: date2)
            .getDocuments { recordsSnapshot, err in
                if let err = err {
                    os_log("Error loading queue records from db.",
                           log: Log.queueRetrievalError,
                           type: .error,
                           err.localizedDescription)
                    return
                }
                recordsSnapshot!.documents.forEach {
                    if $0.data()[Constants.withdrawTimeKey] as? Timestamp != nil {
                        completion(1)
                    }
                }
            }
    }
    
    func fetchBookingCancellationRate(for restaurant: Restaurant,
                                      from date: Date, to date2: Date,
                                      completion: @escaping (Int) -> Void) {
        checkFromToDates(from: date, to: date)

        restaurantBookings(of: restaurant, from: date, to: date2)
            .getDocuments { recordsSnapshot, err in
                if let err = err {
                    os_log("Error loading book records from db.",
                           log: Log.bookRetrievalError,
                           type: .error,
                           err.localizedDescription)
                    return
                }
                recordsSnapshot!.documents.forEach {
                    if $0.data()[Constants.withdrawTimeKey] as? Timestamp != nil {
                        completion(1)
                    }
                }
            }
    }
    
    private func checkFromToDates(from: Date, to: Date) {
        assert(from <= to, "From date should be before or same as to date.")
    }

    private func getEndOfDay(of date: Date) -> Date {
        let calendar = Calendar.current
        let endTime = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date)
        return endTime!
    }

    private func getStartOfDay(of date: Date) -> Date {
        Calendar.current.startOfDay(for: date)
    }

    private func timeDifferenceInSeconds(between start: Date, and end: Date) -> Int {
        Int(end.timeIntervalSince(start))
    }
}
