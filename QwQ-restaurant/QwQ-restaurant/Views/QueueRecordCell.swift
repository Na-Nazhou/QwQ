//
//  QueueRecordCell.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 15/3/20.
//

import UIKit

class QueueRecordCell: UICollectionViewCell {
    var admitAction: (() -> Void)?
    var removeAction: (() -> Void)?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBAction func handleAdmit(_ sender: UIButton) {
        admitAction?()
    }
    
    @IBAction func handleRemove(_ sender: UIButton) {
        removeAction?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    // MARK: Codable

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
