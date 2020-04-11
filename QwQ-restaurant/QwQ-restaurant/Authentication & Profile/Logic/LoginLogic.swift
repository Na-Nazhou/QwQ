//
//  LoginLogic.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 11/4/20.
//

protocol LoginLogic {

    var delegate: LoginLogicDelegate? { get set }

    func beginLogin(authDetails: AuthDetails)

    func getStaffInfo()
}
