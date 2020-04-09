//
//  FIRStaffStorage.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 9/4/20.
//

class FIRStaffStorage: StaffStorage {

    static func createInitialStaffProfile(uid: String,
                                          signupDetails: SignupDetails,
                                          authDetails: AuthDetails,
                                          errorHandler: @escaping (Error) -> Void)

    static func getStaffInfo(completion: @escaping (Staff) -> Void,
                             errorHandler: @escaping (Error) -> Void)

    static func updateStaffInfo()
}
