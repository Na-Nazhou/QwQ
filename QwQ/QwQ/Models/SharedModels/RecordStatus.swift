/// Represents the various status of a record.
enum RecordStatus: Int {
    case pendingAdmission
    case admitted
    case served
    case rejected
    case withdrawn
    case confirmedAdmission
    case missedAndPending
    case invalid
}
