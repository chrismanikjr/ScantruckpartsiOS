//
//  OrderDetailViewController.swift
//  Scantruckparts-iOS
//
//  Created by Chris Manik on 7/8/20.
//  Copyright © 2020 scantruck. All rights reserved.
//

import UIKit
import Firebase
class OrderDetailViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var tableProduct: UITableView!
    @IBOutlet weak var methodLabel: UILabel!
    @IBOutlet weak var transcationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var trackingNumberLabel: UILabel!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    
    var sku = ""
    var index: Int?
    
    let db = Firestore.firestore()
    let currentUser = HomeViewController.shared.user

//    var orderDetail : [OrderDetailData] = []

    var paymentData: [OrderDetailData.Payment] = []
    //    var shippingData: [OrderDetailData.Shipping] = []
    //    var trackingData: [OrderDetailData.Shipping.Tracking] = []
    var productData: [OrderDetailData.Product] = []
    
    var message = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Order Detail"
        tableProduct.dataSource = self
        tableProduct.delegate = self
        tableProduct.register(UINib(nibName: K.cellNibProductList, bundle: nil), forCellReuseIdentifier: K.cellIdentifierProductList)
        
        tableProduct.rowHeight = UITableView.automaticDimension
        tableProduct.estimatedRowHeight = 600
        loadOrder()
        
        
    }
    
    
    func loadOrder(){
//        orderDetail = []
        //        paymentData = []
        //         shippingData = []
        //         trackingData =  []
        productData = []
        let orderHistoryRef = db.collection(K.FStore.orderCollection).document(currentUser.uid)
        orderHistoryRef.addSnapshotListener { (documentSnapshot, error) in
            if let document = documentSnapshot{
                if let orderData = document.data()?[K.FStore.Orders.orderHistory] as? [[String:Any]]{
                    if let orderId = orderData[0][K.FStore.Orders.orderID] as? String, let createdDate: Timestamp = orderData[0][K.FStore.Orders.createdON] as? Timestamp, let totalAmount = orderData[0][K.FStore.Orders.totalAmount] as? Double, let statusOrder = orderData[0][K.FStore.Orders.statusOrder] as? String, let payment = orderData[0][K.FStore.Orders.payment] as? [String:Any], let shipping = orderData[0][K.FStore.Orders.shipping] as? [String: Any], let productList = orderData[0][K.FStore.Orders.product] as?[[String: Any]]{
                        
                        let createdValue = createdDate.dateValue()
                        let dateValue = createdValue.toString(dateFormat: "dd-MMM-yyyy HH:mm:ss")
                        let method = payment[K.FStore.Orders.method] as! String
                        let transId = payment[K.FStore.Orders.transId] as! String
                        
                        let name = shipping[K.FStore.Orders.name] as! String
                        let address = shipping[K.FStore.Orders.address] as! String
                        let telep = shipping[K.FStore.Orders.telep] as! String
//                        let city = shipping[K.FStore.Orders.city] as! String
//                        let region = shipping[K.FStore.Orders.region] as! String
//                        let country = shipping[K.FStore.Orders.country] as! String
//                        let zip = shipping[K.FStore.Orders.zip] as! String
                        
//                        let fullAdress = """
//                        \(address), \(city), \(region), \(country)
//                        \(zip)
//                        """
                        
                        
                        var trackingNum = ""
                        var typeDelivery = ""
                        if let tracking = shipping[K.FStore.Orders.tracking] as? [String:Any]{
//                            let estimated : Timestamp = tracking[K.FStore.Orders.esti] as! Timestamp
//                            let estiValue = estimated.dateValue()
                            let trackNumber = tracking[K.FStore.Orders.trackNumber] as! String
                            let type = tracking[K.FStore.Orders.type] as! String
//                            let status  = tracking[K.FStore.Orders.status] as! String
                            
                            typeDelivery = type
                            trackingNum = trackNumber
//                            let newTrackingData = OrderDetailData.Shipping.Tracking(tracking_number: trackNumber, type_delivery: type, estimated_delivery: estiValue, status_order: status)
                            //                            self.trackingData.append(newTrackingData)
                            
                        }
                        
                        for product in productList{
                            if let sku = product[K.FStore.Orders.sku] as? String, let name = product[K.FStore.Orders.productName] as? String, let image = product[K.FStore.Orders.image] as? String, let price = product[K.FStore.Orders.price] as? Double, let qty = product[K.FStore.Orders.quantity] as? Int{
                                let newProductData = OrderDetailData.Product(image: image, price: price, quantity: qty, sku: sku,name: name)
                                self.productData.append(newProductData)
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.orderNumberLabel.text = orderId
                            self.statusLabel.text = statusOrder
                            self.orderDateLabel.text = dateValue
                            self.methodLabel.text = method
                            self.transcationLabel.text = transId
                            self.totalAmountLabel.text = String("SGD \(totalAmount)")
                            self.typeLabel.text = typeDelivery
                            self.trackingNumberLabel.text = trackingNum
                            self.customerNameLabel.text = name
                            self.telephoneLabel.text = telep
                            self.addressLabel.text = address
                            self.tableProduct.reloadData()
                        }
                        
                        //                        let newShipping = OrderDetailData.Shipping(name: name, telephone_number: telep, address_name: address, city: city, region: region, country: country, zip: zip, tracking: self.trackingData)
                        //
                        let newPayment = OrderDetailData.Payment(method: method, transaction_id: transId)
                        self.paymentData.append(newPayment)
                        
                        //                        let newOrderDetail = OrderDetailData(order_id: orderId, created_on: createdValue, status_order: statusOrder, total_amount: totalAmount, payment: self.paymentData, product: self.productData, shipping: self.shippingData)
                        
                        
                        
                        
                        
                    }
                }
            }else{
                if let e = error{
                    self.message = e.localizedDescription
                    self.alertMessage(with: self.message)
                }
            }
        }
        
    }
    
    //MARK: - Download and load image from Firebase Storage
      
      func loadImage(with imageChild: String) -> StorageReference{
          let storage = Storage.storage()
          let storageRef = storage.reference()
          let ref = storageRef.child(imageChild)
          
          return ref

      }
    
    //MARK: - Message Alert Controller
    func alertMessage(with message: String){
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.orderDeProduct{
            let destinationVC = segue.destination as! ProductDetailController
            destinationVC.skuNumber = sku
        }
    }
    
}
extension OrderDetailViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifierProductList, for: indexPath) as! ProductListCell
        cell.productNameLabel.text = productData[indexPath.row].name
        cell.priceLabel.text = String("SGD \(productData[indexPath.row].price)")
        cell.quantityLabel.text = String("Qty: \(productData[indexPath.row].quantity)")
        let totalAmount = Double(productData[indexPath.row].quantity) * productData[indexPath.row].price
        cell.totalHarga.text = String("SGD \(totalAmount)")
        
        let imageRef = loadImage(with: productData[indexPath.row].image)
        cell.productImage.sd_setImage(with: imageRef)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sku = productData[indexPath.row].sku
        self.performSegue(withIdentifier: K.orderDeProduct, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
extension Date{
    func toString(dateFormat format : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
     
}
