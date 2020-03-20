//
//  ActivityCell.swift
//  QwQ
//
//  Created by Tan Su Yee on 18/3/20.
//

import UIKit

class ActivityCell: UICollectionViewCell {
    var editAction: (() -> Void)?
    var deleteAction: (() -> Void)?

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var deleteButton: UIButton!
    @IBOutlet private var editButton: UIButton!
    @IBOutlet private var estimatedTimeLabel: UILabel!
    @IBOutlet var queueBookImageView: UIImageView!
    
    @IBAction private func handleDelete(_ sender: Any) {
        deleteAction?()
    }

    @IBAction private func handleEdit(_ sender: Any) {
        editAction?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: Codable
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // TODO: take in record protocol instead
    func setUpView(record: Record) {
        nameLabel.text = record.restaurant.name
        descriptionLabel.text = "\(record.groupSize) pax"

        // TODO
        estimatedTimeLabel.text = "Estimated time: 00:00"

        if record.isHistoryRecord {
            editButton.isHidden = true
            deleteButton.isHidden = true
        } else {
            editButton.isHidden = false
            deleteButton.isHidden = false
        }
    }
}
