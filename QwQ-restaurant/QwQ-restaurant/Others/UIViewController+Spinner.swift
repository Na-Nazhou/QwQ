//
//  UIViewController+Spinner.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 20/3/20.
//

import UIKit

extension UIViewController {
    func showSpinner(onView: UIView) -> UIView {
        let spinnerView = UIView(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView()
        ai.startAnimating()
        ai.center = spinnerView.center

        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }

        return spinnerView
    }

    func removeSpinner(_ spinner: UIView?) {
        guard let spinner = spinner else {
            return
        }

        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
