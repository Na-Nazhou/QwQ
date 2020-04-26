import FirebaseFirestore
import FirebaseFirestoreSwift
import os.log

/// A Firestore-based storage handler for restaurants. Reads and listens to changes to documents in Firestore.
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
    
    /// Register to listen to all restaurant documents on Firestore.
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
                    self.parseDocumentChange(diff)
                }
            }
    }

    /// Delegates work to registered delegates based on the document change.
    /// If a valid restaurant is newly added, updated or removed, the delegates will add, update or remove respectively.
    /// - Parameters: diff: Firestore document change for a restaurant document.
    private func parseDocumentChange(_ diff: DocumentChange) {
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
            os_log("Restaurant cannot be created.",
                   log: Log.createRestaurantError, type: .error, error.localizedDescription)
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
    
    /// Removes any registered listener.
    func removeListener() {
        listener?.remove()
        listener = nil
    }
}

extension FIRRestaurantStorage {
    // MARK: - Delegates
    
    /// Register `del` as a delegate of this component.
    func registerDelegate(_ del: RestaurantStorageSyncDelegate) {
        logicDelegates.add(del)
    }
    
    /// Unregister `del` from this component.
    func unregisterDelegate(_ del: RestaurantStorageSyncDelegate) {
        logicDelegates.remove(del)
    }
    
    /// Delegates all registered delegates to do work.
    private func delegateWork(doWork: (RestaurantStorageSyncDelegate) -> Void) {
        for delegate in logicDelegates.allObjects {
            guard let delegate = delegate as? RestaurantStorageSyncDelegate else {
                continue
            }
            doWork(delegate)
        }
    }
}
