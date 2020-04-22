import FirebaseFirestore
import FirebaseFirestoreSwift
import os.log

class FIRRestaurantStorage: RestaurantStorage {
    // MARK: Storage as singleton
    static let shared = FIRRestaurantStorage()

    private init() {}

    // MARK: Storage capabilities
    private let db = Firestore.firestore()
    private var restaurantDb: CollectionReference {
        db.collection(Constants.restaurantsDirectory)
    }

    private let logicDelegates = NSHashTable<AnyObject>.weakObjects()

    private var listener: ListenerRegistration?

    deinit {
        removeListener()
    }
}

extension FIRRestaurantStorage {
    // MARK: - Listeners

    func registerListener() {
        removeListener()

        listener = restaurantDb
            .addSnapshotListener { (snapshot, err) in
                guard err == nil else {
                    os_log("Error getting restaurant documents",
                           log: Log.restaurantRetrievalError,
                           type: .error,
                           String(describing: err))
                    return
                }
                snapshot!.documentChanges.forEach { diff in
                    let result = Result {
                        try diff.document.data(as: Restaurant.self)
                    }
                    var restaurant: Restaurant
                    switch result {
                    case .success(let res):
                        if let res = res {
                            restaurant = res
                            break
                        }
                        os_log("Restaurant document does not exist.", log: Log.createRestaurantError, type: .error)
                        return
                    case .failure(let error):
                        os_log("Restaurant cannot be created.", log: Log.createRestaurantError, type: .error, error.localizedDescription)
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
}

extension FIRRestaurantStorage {
    // MARK: - Delegates

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
