//
//  PermissionCellDelegate.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 25/4/20.
//

protocol PermissionCellDelegate: AnyObject {

    func addPermission(permission: Permission)

    func removePermission(permission: Permission)
}
