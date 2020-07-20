//
//  K.swift
//  Scantruckparts-iOS
//
//  Created by Chris Manik on 7/1/20.
//  Copyright © 2020 scantruck. All rights reserved.
//

import Foundation

struct K{
    static let registerSegue = "RegisterToMain"
    static let loginSegue = "LoginToMain"
    static let historySegueDetail = "OrderHistoryToDetail"
    static let orderDetail = "showOrderDetail"
    
    
    static let cellNibCart = "CartCell"
    static let cellIdentifierCart = "CartReusableCell"
    
    static let cellNibProductList = "ProductListCell"
    static let cellIdentifierProductList = "productListReusable"
    
    static let cellNibOrderHistory  = "OrderHistoryCell"
    static let cellIdentifierOrderHistory = "OrderHistoryReusableCell"
    
    struct FStore{
        static let userCollection = "users"
        static let productCollection = "products"
        static let cartCollection = "carts"
        static let orderCollection = "orders"
        
        static let emailField = "email"
        static let fullNameField = "fullName"
        static let telephoneField = "telephoneNumber"
        static let uidField = "userUID"
        
        struct Cart{
            static let userUID = "userUID"
            static let totalPrice = "total_price"
            static let productCart = "product_cart"
            
            static let sku = "sku"
            static let name = "name"
            static let price = "price"
            static let quantity = "quantity"
            static let image  = "image"
        }
        
        struct Orders {
            static let orderHistory = "order_history"
            static let createdON = "created_on"
            static let orderID = "order_id"
            static let statusOrder  = "status_order"
            static let totalAmount = "total_amount"
            
            static let payment = "payment"
            static let product = "product"
            static let shipping = "shipping"
            static let tracking = "tracking"
            
            static let method = "method"
            static let transId = "transaction_id"
            
            static let address =  "adddress_name"
            static let name = "name"
            static let telep = "telephone_number"
            static let city = "city"
            static let region = "region"
            static let country = "country"
            static let zip = "zip"
            
            static let esti = "estimated_delivery"
            static let trackNumber = "tracking_number"
            static let status = "status"
            static let type = "type_delivery"
            
            static let sku = "sku"
            static let productName = "name"
            static let price = "price"
            static let quantity = "quantity"
            static let image  = "image"
            
        }
    }
}
