//
//  StackCollectionViewCell.swift
//  KipIt
//
//  Created by djepbarov on 1.01.2018.
//  Copyright © 2018 djepbarov. All rights reserved.
//

import UIKit

class StackCollectionViewCell: UICollectionViewCell {
  
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.image = #imageLiteral(resourceName: "defaultPhoto")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
    }
    
}
