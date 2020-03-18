//
//  ActivityCell.swift
//  QwQ
//
//  Created by Tan Su Yee on 18/3/20.
//

import UIKit

class ActivityCell: UICollectionViewCell {
    var editAction: (() -> Void)?

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var deleteButton: UIButton!
    @IBOutlet private var editButton: UIButton!
    @IBOutlet private var estimatedTimeLabel: UILabel!
    @IBOutlet private var queueBookImageView: UIImageView!
    
    @IBAction private func handleDelete(_ sender: Any) {
    }

    @IBAction func handleEdit(_ sender: Any) {
        editAction?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: Codable
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setUpView(queueRecord: QueueRecord) {
        nameLabel.text = queueRecord.restaurant.name
        descriptionLabel.text = "\(queueRecord.groupSize) pax"
        estimatedTimeLabel.text = "00:00"
        if let image = UIImage(named: "c-book-icon") {
            queueBookImageView.image = image
        }
    }
}
