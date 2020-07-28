//
//  Cart.swift
//  Scantruckparts-iOS
//
//  Created by Chris Manik on 7/7/20.
//  Copyright © 2020 scantruck. All rights reserved.
//

import Foundation

struct Cart{
    

    let sku: String
    let name: String
    let image: String
    let price: Double
    let quantity: Int

    let id: String
    var totalPrice: Double{
        return price * Double(quantity)
    }
    
    
}

