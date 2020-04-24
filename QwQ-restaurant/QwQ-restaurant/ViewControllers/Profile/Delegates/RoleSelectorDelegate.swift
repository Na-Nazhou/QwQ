//
//  RoleSelectorDelegate.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 24/4/20.
//

protocol RoleSelectorDelegate: AnyObject {
    func roleSelected(controller: PositionSelectorViewController, selectedRole: String, owner: StaffCell)
}
