/// Represents the protocol a presentation delegate of customer activities should conform to.
protocol ActivitiesDelegate: AnyObject {

    /// Updates the presentation of history records.
    func didUpdateHistoryRecords()

    /// Updates the presentation of active records.
    func didUpdateActiveRecords()

    /// Updates the presentation of missed records.
    func didUpdateMissedRecords()
    
    /// Updates the presentation of records.
    func didWithdrawRecord()

    /// Updates the presentation of records that are confirmed admission.
    func didConfirmAdmissionOfRecord()
}
