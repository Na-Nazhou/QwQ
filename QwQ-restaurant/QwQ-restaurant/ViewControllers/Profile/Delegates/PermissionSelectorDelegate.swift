//
//  PermissionSelectorDelegate.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 25/4/20.
//

protocol PermissionSelectorDelegate: AnyObject {

    func updatePermission(permissions: [Permission], for cell: RoleCell)
}
