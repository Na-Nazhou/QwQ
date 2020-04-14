import Foundation

struct QwQNotificationId: Equatable {
    let recordId: String
    let firstAdmittedTiming: Date?
    let rejectedTiming: Date?
    let targetTime: DateComponents

    var isRejectionNotification: Bool {
        rejectedTiming != nil
    }
    
    var string: String {
        "\(recordId) at \(firstAdmittedTiming) at \(targetTime)"
    }

    init(record: Record, targetTime: Date) {
        recordId = record.id
        self.targetTime = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: targetTime)
        if let time = record.admitTime {
            firstAdmittedTiming = time
            rejectedTiming = nil
        } else {
            assert(record.rejectTime != nil)
            rejectedTiming = record.rejectTime
            firstAdmittedTiming = nil
        }
    }

    init(record: Record, timeInMinutesFromReferenceTime n: Int) {
        var time: Date
        if record.admitTime != nil {
            time = record.admitTime!
            rejectedTiming = nil
            firstAdmittedTiming = time
        } else {
            assert(record.rejectTime != nil)
            time = record.rejectTime!
            firstAdmittedTiming = nil
            rejectedTiming = time
        }
        recordId = record.id
        let triggerDate = Calendar.current.date(byAdding: .minute, value: n, to: time)!
        targetTime = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)
    }
}
