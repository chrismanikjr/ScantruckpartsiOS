//
//  SearchResultCellTableViewCell.swift
//  Scantruckparts-iOS
//
//  Created by Chris Manik on 7/26/20.
//  Copyright © 2020 scantruck. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productImage.showAnimatedGradientSkeleton()
        [nameLabel, descLabel, priceLabel].forEach { $0?.showAnimatedGradientSkeleton()}
        // Initialization code
    }
    
    func hideAnimation(){
        productImage.hideSkeleton()
        [nameLabel, descLabel, priceLabel].forEach { $0?.hideSkeleton()}
    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
