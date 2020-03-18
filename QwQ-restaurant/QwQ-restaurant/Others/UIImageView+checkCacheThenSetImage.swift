//
//  UIImageView+checkCacheThenSetImage.swift
//  QwQ
//
//  Created by Daniel Wong on 18/3/20.
//

import UIKit
import FirebaseStorage
import SDWebImage

extension UIImageView {

    func checkCacheThenSetImage(with reference: StorageReference, placeholder: UIImage? = nil) {
        sd_setImage(with: reference, placeholderImage: placeholder) { [weak self] image, _, _, _ in
            reference.getMetadata { metadata, _ in
                if let url = NSURL.sd_URL(with: reference)?.absoluteString,
                    let cachePath = SDImageCache.shared.cachePath(forKey: url),
                    let attributes = try? FileManager.default.attributesOfItem(atPath: cachePath),
                    let cacheDate = attributes[.creationDate] as? Date,
                    let serverDate = metadata?.timeCreated,
                    serverDate > cacheDate {

                    SDImageCache.shared.removeImage(forKey: url) {
                        self?.sd_setImage(with: reference, placeholderImage: image, completion: nil)
                    }
                }
            }
        }
    }

}
