//
//  PermissionCellDelegate.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 25/4/20.
//

/**
`PermissionCellDelegate` enables handling of action when a permission is added or removed.
 */

protocol PermissionCellDelegate: AnyObject {
    func addPermission(permission: Permission)

    func removePermission(permission: Permission)
}
