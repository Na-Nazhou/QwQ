import FirebaseFirestore

class FBRestaurantStorage: RestaurantStorage {

    let db = Firestore.firestore()

    weak var logicDelegate: RestaurantStorageSyncDelegate?

    init() {
        attachListenerOnRestaurants()
    }

    private func attachListenerOnRestaurants() {
        db.collection(Constants.restaurantsDirectory)
            .addSnapshotListener { (restaurantsSnapshot, err) in
                if let err = err {
                    print("Error fetching documents: \(err)")
                    return
                }
                restaurantsSnapshot!.documentChanges.forEach { diff in
                    guard let restaurant = Restaurant(dictionary: diff.document.data()) else {
                        assert(false, "Restaurant data should always be valid! ?")
                        return
                    }
                    switch diff.type {
                    case .added:
                        self.logicDelegate?.didAddNewRestaurant(restaurant: restaurant)
                    case .modified:
                        self.logicDelegate?.restaurantDidModifyProfile(restaurant: restaurant)
                    case .removed:
                        self.logicDelegate?.didRemoveRestaurant(restaurant: restaurant)
                    }
                }
            }
    }

    func loadAllRestaurants(completion: @escaping (Restaurant) -> Void) {
        db.collection(Constants.restaurantsDirectory).getDocuments { (restaurantsSnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            }
            for document in restaurantsSnapshot!.documents {
                guard let restaurant = Restaurant(dictionary: document.data()) else {
                    continue
                }
                completion(restaurant)
            }
        }
    }
}
