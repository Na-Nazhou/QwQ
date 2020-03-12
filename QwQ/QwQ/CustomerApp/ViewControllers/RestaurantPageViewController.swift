import UIKit
class RestaurantPageViewController: UIViewController, RestaurantLogicDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func restaurantDidSetQueueStatus(of restaurant: Restaurant, toIsOpen isOpen: Bool) {
        //TODO update/toggle queue status on this page
    }
}
