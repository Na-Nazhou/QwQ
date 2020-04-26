//
//  RoleCellDelegate.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 25/4/20.
//

/**
`RoleSelectorDelegate` enables handling of action when the edit permissions is selected.
 */

import UIKit

protocol RoleCellDelegate: AnyObject {
    func editPermissionsButtonPressed(cell: RoleCell, button: UIButton)
}
