//
//  SignupLogic.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 11/4/20.
//

protocol SignupLogic {

    var delegate: SignupLogicDelegate? { get set }

    func beginSignup()
    
}
