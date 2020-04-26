//
//  PopoverContentControllerDelegate.swift
//  QwQ
//
//  Created by Tan Su Yee on 26/4/20.
//

/**
`PopoverContentControllerDelegate` enables handling of action when the popover content is selected
 */

import Foundation

protocol PopoverContentControllerDelegate: AnyObject {
    func popoverContent(controller: PopoverContentController, didselectItem name: String)
}
