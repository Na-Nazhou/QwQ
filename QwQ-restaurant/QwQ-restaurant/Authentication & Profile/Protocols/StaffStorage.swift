//
//  StaffStorage.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 9/4/20.
//

/// This protocol specifies the methods than a compatible profile storage should support.
protocol StaffStorage {

    /// For all of the methods below, the following parameters, if applicable, serve the following purpose:
    /// - Parameters:
    ///     - completion: A closure to be called upon completion of that method
    ///     - errorHandler: A closure that takes an Error type that handles errors

    /// Holds the UID of the currently logged in Staff
    static var currentStaffUID: String? { get set }

    // MARK: - Staff Creation Methods

    /// Creates the initial staff profile for non-owner staff
    /// - Parameters:
    ///     - uid: The uid of the user to be created
    ///     - signupDetails: A SignupDetails object including the name and the contact of the user
    ///     - email: The email of the user to be created
    static func createInitialStaffProfile(uid: String,
                                          signupDetails: SignupDetails,
                                          email: String,
                                          errorHandler: @escaping (Error) -> Void)

    /// Creates the initial staff profile an owner
    /// - Parameters:
    ///     - uid: The uid of the user to be created
    ///     - signupDetails: A SignupDetails object including the name and the contact of the user
    ///     - email: The email of the user to be created
    ///     - assignedRestaurant: The UID of the restaurant created for this owner
    static func createInitialStaffProfile(uid: String,
                                          signupDetails: SignupDetails,
                                          email: String,
                                          assignedRestaurant: String,
                                          errorHandler: @escaping (Error) -> Void)

    // MARK: - Staff Info Retrieval Methods

    /// This function retrieves the respective Staff object based on the currentUID set
    static func getStaffInfo(completion: @escaping (Staff) -> Void,
                             errorHandler: @escaping (Error) -> Void)

    /// This function updates the staff info
    /// - Parameters:
    ///     - staff: The staff to be updated
    static func updateStaffInfo(staff: Staff,
                                completion: @escaping () -> Void,
                                errorHandler: @escaping (Error) -> Void)
}
