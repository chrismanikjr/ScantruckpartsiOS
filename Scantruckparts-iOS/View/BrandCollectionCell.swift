//
//  BrandCollectionCell.swift
//  Scantruckparts-iOS
//
//  Created by Chris Manik on 7/27/20.
//  Copyright © 2020 scantruck. All rights reserved.
//

import UIKit

class BrandCollectionCell: UICollectionViewCell {

    @IBOutlet weak var brandImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        brandImage.contentMode = .scaleAspectFit
        
        // Initialization code
    }

}
