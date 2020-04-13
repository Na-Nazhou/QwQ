import Foundation
import UserNotifications

class LocalNotificationManager {
    
    func listScheduledNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            for notification in notifications {
                print(notification)
            }
        }
    }

    private func requestAuthorization() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if let error = error {
                    assert(false, error.localizedDescription)
                }
                if granted {
                    return
                }
                //TODO: popup alert and redirect to settings
                //problem?: how to know which parent to alert from?
                //UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
        }
    }

    func schedule(notif: Notification) {
        UNUserNotificationCenter.current()
            .getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization()
            case .authorized, .provisional:
                self.scheduleNotification(notif)
            default:
                break // Do nothing --- TODO: request for permissions again?
            }
        }
    }

    private func scheduleNotification(_ notification: Notification) {
        let content = UNMutableNotificationContent()
        content.title = notification.title
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: notification.datetime, repeats: false)
        //TODO: note can also trigger by timeinterval OR GPS. see api

        let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            guard error == nil else { return }

            print("Notification scheduled! --- ID = \(notification.id)")
        }
    }

}

struct Notification {
    var id: String
    var title: String
    var datetime: DateComponents
}
