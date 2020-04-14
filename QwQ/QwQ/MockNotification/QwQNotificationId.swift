import Foundation

struct QwQNotificationId: Equatable {
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
        self.targetTime = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
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
