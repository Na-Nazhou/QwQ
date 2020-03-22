import FirebaseFirestore

class FBRestaurantStorage: RestaurantStorage {

    let db = Firestore.firestore()

    weak var logicDelegate: RestaurantStorageSyncDelegate?

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
