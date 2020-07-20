//
//  Orders.swift
//  Scantruckparts-iOS
//
//  Created by Chris Manik on 7/8/20.
//  Copyright © 2020 scantruck. All rights reserved.
//

import Foundation

struct Orders{
    
    let order_history: [OrderHistory]
    
    struct OrderHistory {
        let order_id: String
        let created_on: Date
        let status_order: String
        let total_amount: Double
        
       
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
    
}
