//
//  PhotosCollectionViewCell.swift
//  KipIt
//
//  Created by djepbarov on 26.01.2018.
//  Copyright © 2018 djepbarov. All rights reserved.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.image = #imageLiteral(resourceName: "defaultPhoto")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
    }
}
