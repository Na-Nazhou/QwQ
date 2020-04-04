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

    func totalNumCustomers(for restaurant: Restaurant, from date: Date, to date2: Date, completion: @escaping (Int) -> Void) {
        checkFromToDates(from: date, to: date)

        queuesDb.whereField(Constants.restaurantKey, isEqualTo: restaurant.uid)
            .whereField(Constants.startTimeKey, isLessThanOrEqualTo: getEndOfDay(of: date2))
            .whereField(Constants.startTimeKey, isGreaterThanOrEqualTo: getStartOfDay(of: date))
            .getDocuments { recordsSnapshot, err in
                if err != nil {
                    os_log("Error loading queue records from db.", log: Log.queueRetrievalError, type: .error)
                    return
                }
                //completion(recordsSnapshot!.count) //num of records or
                recordsSnapshot!.documents.forEach {
                    // num of ppl in the record
                    completion($0.data()[Constants.groupSizeKey] as? Int ?? 0)
                }
        }
    }
    
    func avgWaitingTimeForCustomer(for restaurant: Restaurant, from date: Date, to date2: Date, completion: @escaping (Int) -> Void) {
        checkFromToDates(from: date, to: date)
        
    }
    
    func queueCancellationRate(for restaurant: Restaurant, from date: Date, to date2: Date, completion: @escaping (Int) -> Void) {
        checkFromToDates(from: date, to: date)
        
    }
    
    func bookingCancellationRate(for restaurant: Restaurant, from date: Date, to date2: Date, completion: @escaping (Int) -> Void) {
        checkFromToDates(from: date, to: date)
        
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
        return Calendar.current.startOfDay(for: date)
    }
}
