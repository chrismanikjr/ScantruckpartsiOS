//
//  CartCell.swift
//  Scantruckparts-iOS
//
//  Created by Chris Manik on 7/7/20.
//  Copyright © 2020 scantruck. All rights reserved.
//

import UIKit

protocol CartCollectionProtocol {
    func deleteData(index: Int)
    
    func updateQty(index: Int, qty: Int)
}

class CartCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    var delegate: CartCollectionProtocol?
    var index: IndexPath?
    
    
    var quantityValue = 0.0
    var priceValue = 0.0 
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        delegate?.deleteData(index: index!.row)
    }
   
    @IBAction func quantityStepper(_ sender: UIStepper) {
        quantityValue = sender.value
        let quantity = Int(quantityValue)
        quantityLabel.text = String(format: "%.0f", quantityValue)
        delegate?.updateQty(index: index!.row, qty: quantity)
    }
    
}
