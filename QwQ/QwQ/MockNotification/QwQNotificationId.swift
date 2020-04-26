import Foundation

/// An id of `QwQNotification`. Each `QwQNotificationId` is defined by the related record's id
/// and the time it should trigger at.
struct QwQNotificationId: Equatable {
    let recordId: String
    let targetTime: DateComponents
    
    var toString: String {
        "\(recordId) at \(targetTime)"
    }

    init(record: Record, targetTime: Date) {
        recordId = record.id
        self.targetTime = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: targetTime)
    }

    /// Constructs a `QwQNotificationId` whose trigger time is set to `timeDelayInMinutes` after `afterReference` time.
    /// If afterReference is given non-nil, it will be taken as reference.
    /// Otherwise by default, takes admitTime of record as reference time, if available.
    /// If admitTime is nil, then either rejectTime or withdrawTime must be non-nil and hence taken as reference.
    init(record: Record, timeDelayInMinutes n: Int, afterReference refTime: Date? = nil) {
        var time: Date
        if refTime != nil {
            time = refTime!
        } else {
            if record.admitTime != nil {
                time = record.admitTime!
            } else if record.rejectTime != nil {
                time = record.rejectTime!
            } else {
                assert(record.withdrawTime != nil)
                time = record.withdrawTime!
            }
        }

        recordId = record.id
        let triggerDate = Calendar.current.date(byAdding: .minute, value: n, to: time)!
        targetTime = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)
    }
}
