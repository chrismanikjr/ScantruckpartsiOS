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
   // static let historySegueDetail = "OrderHistoryToDetail"
    static let orderDetail = "showOrderDetail"
    static let toSearch = "goToSearch"
    static let toResult = "goSearchResult"
    static let homeToResult = "homeToResult"
    
    static let homeProduct = "homeToProduct"
    static let orderDeProduct = "detailToProduct"
    static let searchProduct = "searchToProduct"
    static let cartProduct = "cartToProduct"
    
    static let checkout = "toCheckOutAddress"
    static let lastCheckout = "toLastCheckOut"
    
    static let cellNibCart = "CartCell"
    static let cellIdentifierCart = "CartReusableCell"
    
    static let cellNibProductList = "ProductListCell"
    static let cellIdentifierProductList = "productListReusable"
    
    static let cellNibOrderHistory  = "OrderHistoryCell"
    static let cellIdentifierOrderHistory = "OrderHistoryReusableCell"
    
    static let cellSearchResult = "SearchResultCell"
    static let cellIdentifierSearchResult = "SearchResultReusableCell"
    
    static let collectionNewProduct = "NewProductCollectionCell"
    static let collectionIdentifierNewProduct = "NewProductReusableCell"
    
    static let collectionBrand = "BrandCollectionCell"
    static let collectionIdentifierBrand = "BrandReusableCell"
    
    static let checkoutProduct = "CheckoutProductCell"
    static let checkoutProductIdentifier = "CheckoutProductReusable"
    
    struct FStore{
        static let userCollection = "users"
        static let productCollection = "products"
        static let cartCollection = "carts"
        static let orderCollection = "orders"
        static let brandCollection = "brands"
        
        static let emailField = "email"
        static let fullNameField = "fullName"
        static let telephoneField = "telephoneNumber"
        static let uidField = "userUID"
        
        struct Brand{
            static let brand = "brand"
            static let img = "image"
        }
        struct Product{
            static let sku = "sku"
            static let name = "name"
            static let price = "price"
            static let qty = "quantity"
            static let img = "image"
            
            static let desc = "description"
            static let ship = "shipping_details"
            static let date = "created_date"
            static let brand = "brand"
            
            static let weight = "weight"
            static let length = "length"
            static let height = "height"
            static let width = "width"
            
        }
        struct Cart{
            static let email = "email"
            
            static let sku = "sku"
            static let name = "name"
            static let price = "price"
            static let quantity = "quantity"
            static let image  = "image"
            static let date = "created_date"
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
