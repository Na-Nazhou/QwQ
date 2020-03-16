//
//  ProfileImageView.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 16/3/20.
//

import UIKit

class ProfileImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = Constants.profileBorderWidth
        layer.masksToBounds = false
        layer.borderColor = Constants.profileBorderColor
        layer.cornerRadius = frame.height / 2
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
}
