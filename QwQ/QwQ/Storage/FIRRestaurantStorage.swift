import FirebaseFirestore
import os.log

class FIRRestaurantStorage: RestaurantStorage {
    // MARK: Storage as singleton
    static let shared = FIRRestaurantStorage()

    private init() {
        registerListener()
    }

    // MARK: Storage capabilities
    private let db = Firestore.firestore()

    let logicDelegates = NSHashTable<AnyObject>.weakObjects()

    private var listener: ListenerRegistration?

    deinit {
        removeListener()
    }
    
    private func registerListener() {
        listener = db.collection(Constants.restaurantsDirectory)
            .addSnapshotListener { (snapshot, err) in
                if err == nil {
                    os_log("Error getting documents",
                           log: Log.activeQueueRetrievalError,
                           type: .error,
                           String(describing: err))
                    return
                }
                snapshot!.documentChanges.forEach { diff in
                    guard let restaurant = Restaurant(dictionary: diff.document.data()) else {
                        os_log("Restaurant cannot be created.", log: Log.createRestaurantError, type: .error)
                        return
                    }
                    guard restaurant.isValidRestaurant else {
                        os_log("Restaurant is not validated; ignored.", log: Log.createRestaurantError, type: .info)
                        return
                    }
                    switch diff.type {
                    case .added:
                        self.delegateWork { $0.didAddRestaurant(restaurant: restaurant) }
                    case .modified:
                        self.delegateWork { $0.didUpdateRestaurant(restaurant: restaurant) }
                    case .removed:
                        self.delegateWork { $0.didRemoveRestaurant(restaurant: restaurant) }
                    }
                }
            }
    }

    func removeListener() {
        listener?.remove()
        listener = nil
    }

    func registerDelegate(_ del: RestaurantStorageSyncDelegate) {
        logicDelegates.add(del)
    }

    func unregisterDelegate(_ del: RestaurantStorageSyncDelegate) {
        logicDelegates.remove(del)
    }

    private func delegateWork(doWork: (RestaurantStorageSyncDelegate) -> Void) {
        for delegate in logicDelegates.allObjects {
            guard let delegate = delegate as? RestaurantStorageSyncDelegate else {
                continue
            }
            doWork(delegate)
        }
    }
}
