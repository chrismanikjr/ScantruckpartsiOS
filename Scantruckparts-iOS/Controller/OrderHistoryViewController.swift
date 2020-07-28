//
//  OrderHistoryViewController.swift
//  Scantruckparts-iOS
//
//  Created by Chris Manik on 7/8/20.
//  Copyright © 2020 scantruck. All rights reserved.
//

import UIKit
import Firebase

class OrderHistoryViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyImage: UIImageView!
    
    let db = Firestore.firestore()
    let currentUser = Auth.auth().currentUser
    
    var orderHistory : [Orders.OrderHistory] = []
    var orders :[Orders] = []
    var message = ""
    var index = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.cellNibOrderHistory, bundle: nil), forCellReuseIdentifier: K.cellIdentifierOrderHistory)
        loadOrder()
        
        emptyImage.isHidden = true
        
    }
    
    func loadOrder(){
        orderHistory = []
        orders = []
        guard let userUID = currentUser?.uid else{
            return
        }
        let orderHistoryRef = db.collection(K.FStore.orderCollection).document(userUID)
        orderHistoryRef.addSnapshotListener { (documentSnapshot, error) in
            if error == nil{
                if documentSnapshot!.exists{
                    self.tableView.isHidden = false
                    self.emptyImage.isHidden = true
                    
                    let document = documentSnapshot
                    if let orderData = document!.data()?[K.FStore.Orders.orderHistory] as? [[String:Any]]{
                        for data in orderData{
                            if let createdDate : Timestamp = data[K.FStore.Orders.createdON] as? Timestamp, let orderId = data[K.FStore.Orders.orderID] as? String, let statusOrder = data[K.FStore.Orders.statusOrder] as? String, let totalAmount = data[K.FStore.Orders.totalAmount] as? Double{
                                let created = createdDate.dateValue()
                                
                                let newOrderHistory = Orders.OrderHistory(order_id: orderId, created_on: created, status_order: statusOrder, total_amount: totalAmount)
                                self.orderHistory.append(newOrderHistory)
                            }
                        }
                        let newOrders = Orders(order_history: self.orderHistory)
                        self.orders.append(newOrders)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                } else{
                    self.tableView.isHidden = true
                    self.emptyImage.isHidden = false
                    
                }
            }else{
                if let e = error{
                    self.message = e.localizedDescription
                    self.alertMessage(with: self.message)
                    
                }
            }
        }
    }
    
    
    
    
    
    
    //MARK: - Message Alert Controller
    func alertMessage(with message: String){
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}



extension OrderHistoryViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifierOrderHistory, for: indexPath) as! OrderHistoryCell
        let dateString = orderHistory[indexPath.row].created_on
        cell.dateLabel.text = dateString.asString(style: .long)
        cell.noOrderLabel.text = orderHistory[indexPath.row].order_id
        cell.statusLabel.text = orderHistory[indexPath.row].statusFormat
        cell.totalPriceLabel.text = String("SGD \(orderHistory[indexPath.row].total_amount)")
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: K.orderDetail, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        index = indexPath.row
        print(index)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.orderDetail{
            let destinationVC = segue.destination as! OrderDetailViewController
            destinationVC.index = index
            destinationVC.hidesBottomBarWhenPushed = true
        }
    }
    
}
extension Date {
    func asString(style: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }
}


