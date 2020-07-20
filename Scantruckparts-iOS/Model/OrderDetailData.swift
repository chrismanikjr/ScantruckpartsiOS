//
//  OrderDetailData.swift
//  Scantruckparts-iOS
//
//  Created by Chris Manik on 7/8/20.
//  Copyright © 2020 scantruck. All rights reserved.
//

import Foundation
struct OrderDetailData{
    
    let order_id: String
    let created_on: Date
    let status_order: String
    let total_amount: Double
    
    let payment: [Payment]
    let product: [Product]
    let shipping: [Shipping]
    struct Payment {
         let method: String
           let transaction_id: String
    }
    
    struct Product {
        let image: String
        let price: Double
        let quantity: Int
        let sku: String
        let name: String
    }
   
    struct Shipping {
        let name: String
        let telephone_number: String
        let address_name: String
        let city: String
        let region: String
        let country: String
        let zip: String
        let tracking: [Tracking]
        
        struct Tracking {
            let tracking_number: String
            let type_delivery: String
            let estimated_delivery: Date
            let status_order: String
            
        }
    }
    
    
    
    var statusFormat: String{
        switch status_order {
        case "ondelivery":
            return "On Delivery"
        case "complete":
            return "Complete"
        case "packaging":
            return "Packaging"
        default:
            return "Order is accepted"
        }
    }
    
}
