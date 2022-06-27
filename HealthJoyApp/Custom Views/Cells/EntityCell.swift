//
//  EntityCell.swift
//  HealthJoyApp
//
//  Created by Ismael Zavala on 6/22/22.
//

import UIKit
import Gifu

/// Cell used when displaying a giphy result
class EntityCell: UITableViewCell {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var gifView: GIFImageView!
    @IBOutlet weak var userDescriptionLabel: UITextView!
    
    override func prepareForReuse() {
        // Ensuring no images from previous results are shown when reusing the cell
        iconImage.image = nil
        gifView.image = nil
        gifView.isHidden = true
    }
    
    func configureCell(userName: String, userDescription: String, profileImage: Data?, gifData: Data?) {
        userNameLabel.text = userName
        userDescriptionLabel.text = userDescription
        
        gifView.isHidden = false
        
        if let profileData = profileImage, let userImage = UIImage(data: profileData) {
            iconImage.image = userImage
        }
        
        if let passedGifData = gifData {
            gifView.animate(withGIFData: passedGifData)
        }
    }
}
