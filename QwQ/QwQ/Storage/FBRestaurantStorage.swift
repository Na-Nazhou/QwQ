import FirebaseFirestore
import os.log

class FBRestaurantStorage: RestaurantStorage {

    let db = Firestore.firestore()

    weak var logicDelegate: RestaurantStorageSyncDelegate?

    private var listener: ListenerRegistration?

    init() {
        attachListenerOnRestaurants()
    }

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
                        assert(false, "Restaurant data should always be valid! ?")
                        return
                    }
                    switch diff.type {
                    case .added:
                        self.logicDelegate?.didAddRestaurant(restaurant: restaurant)
                    case .modified:
                        self.logicDelegate?.restaurantDidModifyProfile(restaurant: restaurant)
                    case .removed:
                        self.logicDelegate?.didRemoveRestaurant(restaurant: restaurant)
                    }
                }
            }
    }
}
