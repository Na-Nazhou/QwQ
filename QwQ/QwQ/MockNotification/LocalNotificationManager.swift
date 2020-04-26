import Foundation
import os.log
import UIKit
import UserNotifications

/// A general local notifications scheduler that uses the `UserNotifictions` framework..
class LocalNotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let singleton = LocalNotificationManager()

    let notificationCenter = UNUserNotificationCenter.current()

    override private init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}

extension LocalNotificationManager {

    /// Requests for user permission to allow notifications.
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if let error = error {
                    assert(false, error.localizedDescription)
                    return
                }
                if granted {
                    return
                }
                os_log("Notif auth request rejected.", log: Log.requestPermissionsFail, type: .info)
                self.requestForPermissionsAgain()
        }
    }

    /// Schedules a notification if authorized. Requests authorization if not yet asked.
    func schedule(notif: Notification) {
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                self.scheduleNotification(notif)
            case .denied:
                break
            case .notDetermined:
                assert(false, "?")
                self.requestAuthorization()
            @unknown default:
                fatalError("auth status \(settings.authorizationStatus) not supported yet!")
                }
        }
    }

    /// Requests authorization for notifications by asking to open settings.
    private func requestForPermissionsAgain() {
        let alertController = UIAlertController(
            title: Constants.notificationPermissionRequiredTitle,
            message: Constants.notificationPermissionRequiredMessage,
            preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { success in
                    os_log("Successfully opened Settings!", log: Log.redirectToSettings, type: .info)
                    print(success)
                })
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        DispatchQueue.main.async {
            UIApplication.getTopMostViewController()?
                .present(alertController, animated: true, completion: nil)

        }
    }

    /// Sends the notification to be scheduled in the framework.
    private func scheduleNotification(_ notification: Notification) {
        let content = UNMutableNotificationContent()
        content.title = notification.title
        content.body = notification.description
        content.sound = .default

        // set to trigger immediately if target time is outdated.
        var trigger: UNNotificationTrigger?
        if Calendar.current.date(from: notification.timeScheduled)! <= Date()
            && notification.shouldBeSentRegardlessOfTime {
            trigger = nil
        } else {
            trigger = UNCalendarNotificationTrigger(dateMatching: notification.timeScheduled, repeats: false)
        }

        let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)

        notificationCenter.add(request) { error in
            guard error == nil else {
                os_log("Failed to schedule notification.", log: Log.scheduleError, type: .error)
                return
            }

            os_log("Notification successfully scheduled!", log: Log.scheduleSuccess, type: .info)
        }
    }

    /// Remove all notifications, if any, identified by ids in `ids`.
    func removeNotifications(ids: [String]) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ids)
    }

}
