//
//  ActivityCell.swift
//  QwQ
//
//  Created by Tan Su Yee on 18/3/20.
//

import UIKit

class ActivityCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var estimatedTimeLabel: UILabel!
    @IBOutlet weak var queueBookImageView: UIImageView!
    
    @IBAction func handleDelete(_ sender: Any) {
    }
    
    @IBAction func handleEdit(_ sender: Any) {
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: Codable
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
