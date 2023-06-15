//
//  GalleryViewCell.swift
//  photosApp
//
//  Created by Tiara H on 13/06/23.
//

import UIKit

class GalleryViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    static let cellIdentifier = "galleryCellId"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }
    
    func setup() {
        thumbImageView.contentMode = .scaleAspectFill
    }
    
}
