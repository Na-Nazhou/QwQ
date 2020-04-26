/// Represents the protocol a presentation deelgate of statistics should conform to.
protocol StatsDelegate: AnyObject {
    /// Updates the presentation of statistics.
    func didCompleteFetchingData()
}

/// Represents the procol a detailed stats presentation delegate should conform to.
protocol StatsDetailsDelegate: AnyObject {
    /// Updates the presentation of the detailed statistics.
    func didCompleteFetchingData()
}
