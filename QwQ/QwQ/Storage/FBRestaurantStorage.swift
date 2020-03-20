import FirebaseFirestore
class FBRestaurantStorage: RestaurantStorage {

    let db: Firestore

    weak var logicDelegate: RestaurantStorageSyncDelegate?

    init() {
        self.db = Firestore.firestore()
    }

    func restaurantDidOpenQueue(restaurant: Restaurant) {
        logicDelegate?.restaurantDidOpenQueue(restaurant: restaurant)
    }

    func restaurantDidCloseQueue(restaurant: Restaurant) {
        logicDelegate?.restaurantDidOpenQueue(restaurant: restaurant)
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
