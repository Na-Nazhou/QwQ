import Foundation
import os.log
import UserNotifications

/// Example request to schedule notifs: LocalNotificationManager.schedule(notif: Notification(id: "reminder-1", title: "Remember the milk!", timeInterval: 0))
class LocalNotificationManager {
    
    func listScheduledNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            for notification in notifications {
                print(notification)
            }
        }
    }

    func requestAuthorization() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if let error = error {
                    assert(false, error.localizedDescription)
                }
                if granted {
                    return
                }
                os_log("Notif auth request rejected.", log: Log.requestPermissionsFail, type: .info)
                self.requestForPermissionsAgain()
                //TODO: popup alert and redirect to settings
                //problem?: how to know which parent to alert from?
                //UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
            }
    }

    func schedule(notif: Notification) {
        UNUserNotificationCenter.current()
            .getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                self.scheduleNotification(notif)
            default:
                self.requestForPermissionsAgain()
                break // Do nothing --- TODO: request for permissions again?
            }
            }
    }

    private func requestForPermissionsAgain() {
        
    }

    private func scheduleNotification(_ notification: Notification) {
        let content = UNMutableNotificationContent()
        content.title = notification.title
        content.sound = .default

        var trigger: UNNotificationTrigger?
        if notification.timeInterval <= 0 {
            trigger = nil
        } else {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: notification.timeInterval, repeats: false)
        }

        let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            guard error == nil else {
                os_log("Failed to schedule notification.", log: Log.scheduleError, type: .error)
                return
            }

            os_log("Notification successfully scheduled!", log: Log.scheduleSuccess, type: .info)
        }
    }

}

struct Notification {
    var id: String
    var title: String
    //var datetime: DateComponents
    var timeInterval: Double
}
