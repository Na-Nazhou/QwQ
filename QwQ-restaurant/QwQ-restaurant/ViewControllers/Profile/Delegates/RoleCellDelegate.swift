//
//  RoleCellDelegate.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 25/4/20.
//

import UIKit

protocol RoleCellDelegate: AnyObject {

    func editPermissionsButtonPressed(cell: RoleCell, button: UIButton)
}
