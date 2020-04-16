import Foundation
import os.log
import UIKit
import UserNotifications

/// General notifications scheduler.
class LocalNotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let singleton = LocalNotificationManager()

    let notificationCenter = UNUserNotificationCenter.current()

    private override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}

extension LocalNotificationManager {

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

    private func requestForPermissionsAgain() {
        let alertController = UIAlertController(
            title: "Notifications Required!",
            message: "Notifications are necessary to respond to your queues/bookings promptly!"
                + " Please head over to Settings and enable notifications for QwQ.",
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

    private func scheduleNotification(_ notification: Notification) {
        let content = UNMutableNotificationContent()
        content.title = notification.title
        content.body = notification.description
        content.sound = .default

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

    func removeNotifications(ids: [String]) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ids)
    }

}