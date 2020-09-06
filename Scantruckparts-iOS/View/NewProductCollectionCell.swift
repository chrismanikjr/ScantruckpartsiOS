//
//  NewProductCollectionCell.swift
//  Scantruckparts-iOS
//
//  Created by Chris Manik on 7/26/20.
//  Copyright © 2020 scantruck. All rights reserved.
//

import UIKit
import SkeletonView
class NewProductCollectionCell: UICollectionViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productImage.showAnimatedGradientSkeleton()
        nameLabel.showAnimatedGradientSkeleton()
    }
//
    func hideAnimation(){
        productImage.hideSkeleton()
        nameLabel.hideSkeleton()
    }
    
    

}
