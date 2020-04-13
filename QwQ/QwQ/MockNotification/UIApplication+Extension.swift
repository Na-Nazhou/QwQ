import UIKit

extension UIApplication {
    class func topViewController(
        controller: UIViewController? = nil,
        isSearchFromRoot: Bool = true) -> UIViewController? {
        if !isSearchFromRoot && controller == nil {
            return nil
        }
        
        var controller = controller
        if controller == nil {
            // in case of multiple scenes
            // UIApplication.shared.keyWindow is deprecated as of iOS13.
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            controller = keyWindow?.rootViewController
        }

        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented, isSearchFromRoot: false)
        }

        if let tabController = controller as? UITabBarController {
            return topViewController(controller: tabController.selectedViewController, isSearchFromRoot: false)
        }

        if let navController = controller as? UINavigationController {
            return topViewController(controller: navController.visibleViewController, isSearchFromRoot: false)
        }

        return controller
    }
}
