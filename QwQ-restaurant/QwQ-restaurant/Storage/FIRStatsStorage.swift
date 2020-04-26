import FirebaseFirestore
import os.log

/// A Firetore-based storage handler for restaurant statistics. Reads from documents on Firestore.
class FIRStatsStorage: RestaurantStatsStorage {
    // MARK: Storage as singleton
    static let shared = FIRStatsStorage()

    // MARK: Storage capabilities
    private let db = Firestore.firestore()
    private var queuesDb: CollectionReference {
        db.collection(Constants.queuesDirectory)
    }
    private var bookingDb: CollectionReference {
        db.collection(Constants.bookingsDirectory)
    }

    /// Returns the reference to the query for `restaurant` data that falls in time period stated in `stats`.
    /// - Parameters:
    ///     - restaurant: the restaurant to retrieve stats for,
    ///     - stats: the stats with date stated.
    ///     - collectionRef: the type of collection to retrieve stats from.
    ///     - key: the time key to compare.
    /// - Returns: filtered query object
    private func getRecordQuery(of restaurant: Restaurant, stats: Statistics,
                                in collectionRef: CollectionReference, for key: String) -> Query {
        collectionRef.whereField(Constants.restaurantKey, isEqualTo: restaurant.uid)
            .whereField(key, isGreaterThanOrEqualTo: stats.fromDate)
            .whereField(key, isLessThanOrEqualTo: stats.toDate)
    }

    private func restaurantQueues(of restaurant: Restaurant, stats: Statistics) -> Query {
        checkFromToDates(from: stats.fromDate, to: stats.toDate)

        return getRecordQuery(of: restaurant, stats: stats, in: queuesDb, for: Constants.startTimeKey)
    }

    private func restaurantBookings(of restaurant: Restaurant, stats: Statistics) -> Query {
        getRecordQuery(of: restaurant, stats: stats, in: bookingDb, for: Constants.timeKey)
    }

    /// Fetch total number of customers for `restaurant` and perform `completion` on the retrieved statitic.
    func fetchTotalNumCustomers(for restaurant: Restaurant,
                                stats: Statistics,
                                completion: @escaping (Int) -> Void) {
        restaurantQueues(of: restaurant, stats: stats)
            .getDocuments { snapshot, err in
                guard let snapshot = snapshot, err == nil else {
                    os_log("Error loading queue records from db.",
                           log: Log.queueRetrievalError,
                           type: .error,
                           String(describing: err))
                    return
                }

                var totalNumOfCustomers = 0
                snapshot.documents.forEach {
                    totalNumOfCustomers += $0.data()[Constants.groupSizeKey] as? Int ?? 0
                }

                self.restaurantBookings(of: restaurant, stats: stats)
                .getDocuments { snapshot, err in
                    guard let snapshot = snapshot, err == nil else {
                        os_log("Error loading book records from db.",
                               log: Log.bookRetrievalError,
                               type: .error,
                               String(describing: err))
                        return
                    }
                    snapshot.documents.forEach {
                        totalNumOfCustomers += $0.data()[Constants.groupSizeKey] as? Int ?? 0
                    }
                    completion(totalNumOfCustomers)
                }
            }
    }

    /// Fetch total waiting time for customers for `restaurant` and perform `completion` on the retrieved statitic.
    /// Waiting time for customers refer to the time customers have to wait to be admitted.
    func fetchTotalWaitingTimeForCustomer(for restaurant: Restaurant,
                                          stats: Statistics,
                                          completion: @escaping (Int) -> Void) {
        restaurantQueues(of: restaurant, stats: stats)
            .getDocuments { snapshot, err in
                guard let snapshot = snapshot, err == nil else {
                    os_log("Error loading queue records from db.",
                           log: Log.queueRetrievalError,
                           type: .error,
                           String(describing: err))
                    return
                }

                var totalWaitingTime = 0
                snapshot.documents.forEach {
                    let dict = $0.data()
                    guard let startTime = (dict[Constants.startTimeKey] as? Timestamp)?.dateValue(),
                        let admitTime = (dict[Constants.admitTimeKey] as? Timestamp)?.dateValue() else {
                            return
                    }
                    totalWaitingTime += self.timeDifferenceInSeconds(between: startTime, and: admitTime)
                }
                completion(totalWaitingTime)
            }
    }

    /// Fetch total waiting time for `restaurant` and perform `completion` on the retrieved statitic.
    /// Waiting time for restaurants refer to the time restaurants have to wait for customers to turn up.
    func fetchTotalWaitingTimeForRestaurant(for restaurant: Restaurant,
                                            stats: Statistics,
                                            completion: @escaping (Int) -> Void) {
        restaurantQueues(of: restaurant, stats: stats)
            .getDocuments { snapshot, err in
                guard let snapshot = snapshot, err == nil else {
                    os_log("Error loading queue records from db.",
                           log: Log.queueRetrievalError,
                           type: .error,
                           String(describing: err))
                    return
                }
                var totalWaitingTime = 0
                snapshot.documents.forEach {
                    let dict = $0.data()
                    guard let admitTime = (dict[Constants.admitTimeKey] as? Timestamp)?.dateValue(),
                        let serveTime = (dict[Constants.serveTimeKey] as? Timestamp)?.dateValue() else {
                            return
                    }
                    totalWaitingTime += self.timeDifferenceInSeconds(between: admitTime, and: serveTime)
                }
                completion(totalWaitingTime)
            }
    }
    
    /// Fetch queue cancellation rate for `restaurant` and perform `completion` on the retrieved statitic.
    func fetchQueueCancellationRate(for restaurant: Restaurant,
                                    stats: Statistics,
                                    completion: @escaping (Int, Int) -> Void) {
        restaurantQueues(of: restaurant, stats: stats)
            .getDocuments { snapshot, err in
                guard let snapshot = snapshot, err == nil else {
                    os_log("Error loading queue records from db.",
                           log: Log.queueRetrievalError,
                           type: .error,
                           String(describing: err))
                    return
                }
                var totalNumOfQueueRecords = 0
                var totalNumOfWithdrawal = 0
                snapshot.documents.forEach {
                    if $0.data()[Constants.withdrawTimeKey] as? Timestamp != nil {
                        totalNumOfWithdrawal += 1
                    }
                    totalNumOfQueueRecords += 1
                }
                completion(totalNumOfQueueRecords, totalNumOfWithdrawal)
            }
    }
    
    /// Fetch booking cancellation rate for `restaurant` and perform `completion` on the retrieved statitic.
    func fetchBookingCancellationRate(for restaurant: Restaurant,
                                      stats: Statistics,
                                      completion: @escaping (Int, Int) -> Void) {
        restaurantBookings(of: restaurant, stats: stats)
            .getDocuments { snapshot, err in
                guard let snapshot = snapshot, err == nil else {
                    os_log("Error loading book records from db.",
                           log: Log.bookRetrievalError,
                           type: .error,
                           String(describing: err))
                    return
                }
                var totalNumOfBookRecords = 0
                var totalNumberOfWithdrawal = 0
                snapshot.documents.forEach {
                    if $0.data()[Constants.withdrawTimeKey] as? Timestamp != nil {
                        totalNumberOfWithdrawal += 1
                    }
                    totalNumOfBookRecords += 1
                }
                completion(totalNumOfBookRecords, totalNumberOfWithdrawal)
            }
    }
    
    private func checkFromToDates(from: Date, to: Date) {
        assert(from <= to, "From date should be before or same as to date.")
    }

    private func timeDifferenceInSeconds(between start: Date, and end: Date) -> Int {
        Int(end.timeIntervalSince(start))
    }
}
