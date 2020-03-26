enum RecordStatus: Int {
    case pendingAdmission
    case admitted
    case served
    case rejected
    case invalid
}

enum RecordModification: Int {
    case customerUpdate
    case admit
    case reject
    case serve
}
