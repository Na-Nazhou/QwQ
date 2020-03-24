enum RecordStatus: Int {
    case pendingAdmission
    case admitted
    case served
    case rejected
    case invalid
}

enum RecordModificationType {
    case customerUpdate
    case admit
    case reject
    case serve
}
