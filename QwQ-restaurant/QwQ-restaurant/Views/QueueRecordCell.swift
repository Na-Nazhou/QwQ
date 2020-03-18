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
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    @IBAction private func handleAdmit(_ sender: UIButton) {
        admitAction?()
    }
    
    @IBAction private func handleRemove(_ sender: UIButton) {
        removeAction?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    // MARK: Codable

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setUpView(record: Record) {
        nameLabel.text = record.customer.name
        descriptionLabel.text = "\(record.groupSize) pax"
    }
}
