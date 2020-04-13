import Foundation

struct Notification {
    let notifId: QwQNotificationId
    let title: String
    let description: String
    let shouldBeSentRegardlessOfTime: Bool

    var timeScheduled: DateComponents {
        notifId.targetTime
    }
    var id: String {
        notifId.string
    }
    
    init(notifId: QwQNotificationId, title: String, description: String, shouldSend: Bool) {
        self.notifId = notifId
        self.title = title
        self.description = description
        shouldBeSentRegardlessOfTime = shouldSend
    }
}

struct QwQNotificationId {
    let recordId: String
    let firstAdmittedTiming: Date
    let targetTime: DateComponents
    
    var string: String {
        "\(recordId) at \(firstAdmittedTiming) with interval \(targetTime)"
    }

    init?(record: Record, targetTime: Date) {
        guard let time = record.admitTime else {
            assert(false)
            return nil
        }
        recordId = record.id
        firstAdmittedTiming = time
        self.targetTime = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                          from: targetTime)
    }

    init?(record: Record, timeInMinutesFromAdmittedTime n: Int) {
        guard let time = record.admitTime else {
            assert(false)
            return nil
        }
        recordId = record.id
        firstAdmittedTiming = time
        let triggerDate = Calendar.current.date(byAdding: .minute, value: n, to: time)!
        targetTime = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)
    }
}

//struct NotificationType {
//    let action: RestaurantAction
//    let option:
//}
