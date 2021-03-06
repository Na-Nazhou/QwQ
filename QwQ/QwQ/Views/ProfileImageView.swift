//
//  ProfileImageView.swift
//  QwQ
//
//  Created by Tan Su Yee on 18/3/20.
//

import UIKit

class ProfileImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        layer.borderWidth = Constants.profileBorderWidth
        layer.masksToBounds = false
        contentMode = .scaleAspectFill
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderColor = Constants.profileBorderColor
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
    }
}
