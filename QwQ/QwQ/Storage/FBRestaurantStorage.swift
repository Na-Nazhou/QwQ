import FirebaseFirestore
import os.log

class FBRestaurantStorage: RestaurantStorage {
    // MARK: Storage as singleton
    static let shared = FBRestaurantStorage()

    private init() {
        attachListenerOnRestaurants()
    }

    // MARK: Storage capabilities
    private let db = Firestore.firestore()

    let logicDelegates = NSHashTable<AnyObject>.weakObjects()

    private var listener: ListenerRegistration?

    deinit {
        listener?.remove()
    }
    
    private func attachListenerOnRestaurants() {
        listener = db.collection(Constants.restaurantsDirectory)
            .addSnapshotListener { (snapshot, err) in
                if let err = err {
                    os_log("Error getting documents",
                           log: Log.activeQueueRetrievalError,
                           type: .error,
                           String(describing: err))
                    return
                }
                snapshot!.documentChanges.forEach { diff in
                    guard let restaurant = Restaurant(dictionary: diff.document.data()) else {
//                        assert(false, "Restaurant data should always be valid! ?")
                        os_log("Restaurant cannot be created.", log: Log.createRestaurantError, type: .error)
                        return
                    }
                    switch diff.type {
                    case .added:
                        self.delegateWork { $0.didAddRestaurant(restaurant: restaurant) }
                    case .modified:
                        self.delegateWork { $0.restaurantDidModifyProfile(restaurant: restaurant) }
                    case .removed:
                        self.delegateWork { $0.didRemoveRestaurant(restaurant: restaurant) }
                    }
                }
        }
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
