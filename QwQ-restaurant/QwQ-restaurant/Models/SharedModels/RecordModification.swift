///  Represents the various modifications from a record state to successive state.
enum RecordModification: Int {
    case customerUpdate
    case admit
    case reject
    case serve
    case withdraw
    case confirmAdmission
    case miss
    case readmit
}
