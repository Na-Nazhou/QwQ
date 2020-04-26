//
//  RoleSelectorDelegate.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 24/4/20.
//

/**
`RoleSelectorDelegate` enables handling of action when the role cell is selected.
 */

protocol RoleSelectorDelegate: AnyObject {
    func roleSelected(controller: PositionSelectorViewController, selectedRole: String, owner: StaffCell)
}
