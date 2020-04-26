//
//  StaffCellDelegate.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 24/4/20.
//

/**
`StaffCellDelegate` enables handling of action when the staff cell is selected.
 */

import UIKit

protocol StaffCellDelegate: AnyObject {
    func editRoleButtonPressed(cell: StaffCell, button: UIButton)
}
