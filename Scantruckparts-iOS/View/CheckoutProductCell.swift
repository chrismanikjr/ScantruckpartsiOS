//
//  CheckoutProductCell.swift
//  Scantruckparts-iOS
//
//  Created by Chris Manik on 7/29/20.
//  Copyright © 2020 scantruck. All rights reserved.
//

import UIKit
import SkeletonView

class CheckoutProductCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        productImage.showAnimatedGradientSkeleton()
        nameLabel.showAnimatedGradientSkeleton()
        priceLabel.showAnimatedGradientSkeleton()
        qtyLabel.showAnimatedGradientSkeleton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func hideAnimation(){
        productImage.hideSkeleton()
        nameLabel.hideSkeleton()
        priceLabel.hideSkeleton()
        qtyLabel.hideSkeleton()
    }
    
}
