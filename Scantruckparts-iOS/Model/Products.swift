//
//  CartProduct.swift
//  Scantruckparts-iOS
//
//  Created by Chris Manik on 7/7/20.
//  Copyright © 2020 scantruck. All rights reserved.
//

import Foundation

struct Products{
    
    let sku: String
    let name: String
    let price: Double
    let quantity: Int
    let image: String
    
    let description: String
    let shipping_details: [ShippingDetails]
    
    let brand: String
    struct ShippingDetails{
        let weight: Double
        let length: Double
        let height: Double
        let width: Double
    }
    
}
