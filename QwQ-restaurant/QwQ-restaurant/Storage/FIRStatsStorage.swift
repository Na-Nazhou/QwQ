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

    private func getRecordQuery(of restaurant: Restaurant, from date1: Date, to date2: Date,
                                in collectionRef: CollectionReference, for key: String) -> Query {
        collectionRef.whereField(Constants.restaurantKey, isEqualTo: restaurant.uid)
            .whereField(key, isGreaterThanOrEqualTo: date1)
            .whereField(key, isLessThanOrEqualTo: date2)
    }

    private func restaurantQueues(of restaurant: Restaurant, from date1: Date, to date2: Date) -> Query {
        getRecordQuery(of: restaurant, from: date1, to: date2, in: queuesDb, for: Constants.startTimeKey)
    }

    private func restaurantBookings(of restaurant: Restaurant, from date1: Date, to date2: Date) -> Query {
        getRecordQuery(of: restaurant, from: date1, to: date2, in: bookingDb, for: Constants.timeKey)
    }

    func fetchTotalNumCustomers(for restaurant: Restaurant,
                                from date1: Date, to date2: Date,
                                completion: @escaping (Int) -> Void) {
        checkFromToDates(from: date1, to: date2)

        restaurantQueues(of: restaurant, from: date1, to: date2)
            .getDocuments { snapshot, err in
                guard let snapshot = snapshot, err == nil else {
                    os_log("Error loading queue records from db.",
                           log: Log.queueRetrievalError,
                           type: .error,
                           String(describing: err))
                    return
                }
                //completion(recordsSnapshot!.count) //num of records or

                var total = 0
                snapshot.documents.forEach {
                    // num of ppl in the record
                    total += $0.data()[Constants.groupSizeKey] as? Int ?? 0
                }

                self.restaurantBookings(of: restaurant, from: date1, to: date2)
                .getDocuments { snapshot, err in
                    guard let snapshot = snapshot, err == nil else {
                        os_log("Error loading book records from db.",
                               log: Log.bookRetrievalError,
                               type: .error,
                               String(describing: err))
                        return
                    }
                    snapshot.documents.forEach {
                        total += $0.data()[Constants.groupSizeKey] as? Int ?? 0
                    }
                    completion(total)
                }
            }
    }
    
    func fetchTotalWaitingTimeForCustomer(for restaurant: Restaurant,
                                          from date1: Date, to date2: Date,
                                          completion: @escaping (Int) -> Void) {
        checkFromToDates(from: date1, to: date2)

        restaurantQueues(of: restaurant, from: date1, to: date2)
            .getDocuments { snapshot, err in
                guard let snapshot = snapshot, err == nil else {
                    os_log("Error loading queue records from db.",
                           log: Log.queueRetrievalError,
                           type: .error,
                           String(describing: err))
                    return
                }

                var total = 0
                snapshot.documents.forEach {
                    let dict = $0.data()
                    guard let startTime = (dict[Constants.startTimeKey] as? Timestamp)?.dateValue(),
                        let admitTime = (dict[Constants.admitTimeKey] as? Timestamp)?.dateValue() else {
                            return
                    }
                    total += self.timeDifferenceInSeconds(between: startTime, and: admitTime)
                }
                completion(total)
            }
    }

    func fetchTotalWaitingTimeForRestaurant(for restaurant: Restaurant,
                                            from date1: Date, to date2: Date,
                                            completion: @escaping (Int) -> Void) {
        checkFromToDates(from: date1, to: date2)

        restaurantQueues(of: restaurant, from: date1, to: date2)
            .getDocuments { snapshot, err in
                guard let snapshot = snapshot, err == nil else {
                    os_log("Error loading queue records from db.",
                           log: Log.queueRetrievalError,
                           type: .error,
                           String(describing: err))
                    return
                }
                var total = 0
                snapshot.documents.forEach {
                    let dict = $0.data()
                    guard let serveTime = (dict[Constants.serveTimeKey] as? Timestamp)?.dateValue(),
                        let admitTime = (dict[Constants.admitTimeKey] as? Timestamp)?.dateValue() else {
                            return
                    }
                    total += self.timeDifferenceInSeconds(between: admitTime, and: serveTime)
                }
                completion(total)
            }
    }
    
    func fetchQueueCancellationRate(for restaurant: Restaurant,
                                    from date1: Date, to date2: Date,
                                    completion: @escaping (Int) -> Void) {
        checkFromToDates(from: date1, to: date2)

        restaurantQueues(of: restaurant, from: date1, to: date2)
            .getDocuments { snapshot, err in
                guard let snapshot = snapshot, err == nil else {
                    os_log("Error loading queue records from db.",
                           log: Log.queueRetrievalError,
                           type: .error,
                           String(describing: err))
                    return
                }
                var total = 0
                snapshot.documents.forEach {
                    if $0.data()[Constants.withdrawTimeKey] as? Timestamp != nil {
                        total += 1
                    }
                }
                completion(total)
            }
    }
    
    func fetchBookingCancellationRate(for restaurant: Restaurant,
                                      from date1: Date, to date2: Date,
                                      completion: @escaping (Int) -> Void) {
        checkFromToDates(from: date1, to: date2)

        restaurantBookings(of: restaurant, from: date1, to: date2)
            .getDocuments { snapshot, err in
                guard let snapshot = snapshot, err == nil else {
                    os_log("Error loading book records from db.",
                           log: Log.bookRetrievalError,
                           type: .error,
                           String(describing: err))
                    return
                }
                var total = 0
                snapshot.documents.forEach {
                    if $0.data()[Constants.withdrawTimeKey] as? Timestamp != nil {
                        total += 1
                    }
                }
                completion(total)
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
