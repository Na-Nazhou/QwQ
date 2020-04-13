//
//  NotificationViewer.swift
//  QwQ
//
//  Created by Happy on 13/4/20.
//

import UIKit

class NotificationViewer {
    static let manager = NotificationViewer()
    private init() {}

    private var currentPresenter: UIViewController?

    static func notify(title: String, message: String, options: [NotificationOptions]) {
        assert(manager.currentPresenter != nil,
               "There should always be a view controller registered as current presenter!")
        //TODO
        
    }

    static func registerAsCurrentPresenter(current: UIViewController) {
        manager.currentPresenter = current
    }
}

struct NotificationOptions {
    /// Display name on button.
    let actionName: String
    /// Description of action to be displayed when hovered over?
    let description: String?
    /// Completion upon selecting this option.
    let completion: () -> Void
}
