//
//  StaffStorage.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 9/4/20.
//

protocol StaffStorage {

    static var currentStaffUID: String? { get set }

    /// Create initial staff profile for non-owner staff
    static func createInitialStaffProfile(uid: String,
                                          signupDetails: SignupDetails,
                                          email: String,
                                          errorHandler: @escaping (Error) -> Void)

    /// Create initial staff profile for owner
    static func createInitialStaffProfile(uid: String,
                                          signupDetails: SignupDetails,
                                          email: String,
                                          assignedRestaurant: String,
                                          errorHandler: @escaping (Error) -> Void)

    static func getStaffInfo(completion: @escaping (Staff) -> Void,
                             errorHandler: @escaping (Error) -> Void)

    static func updateStaffInfo(staff: Staff,
                                completion: @escaping () -> Void,
                                errorHandler: @escaping (Error) -> Void)
}
