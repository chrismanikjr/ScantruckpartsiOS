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
//        setImageConstraints()
        productImage.contentMode = .scaleAspectFit
        productImage.showAnimatedGradientSkeleton()
        nameLabel.showAnimatedGradientSkeleton()
    }
    
    func setNewProduct(with product: HomeNewProduct){
        self.hideAnimation()
        let refImage = Utilities.loadImage(with: product.image)
        productImage.sd_setImage(with: refImage)
        nameLabel.text = product.name
    }
//
    
//    func setImageConstraints(){
//        productImage.translatesAutoresizingMaskIntoConstraints = false
//        productImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        productImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
//        productImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
//        productImage.widthAnchor.constraint(equalTo: productImage.heightAnchor, multiplier: 16/9).isActive = true
//    }
    
    func hideAnimation(){

        productImage.hideSkeleton()
        nameLabel.hideSkeleton()
    }
    
    

}
