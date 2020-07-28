//
//  CartViewController.swift
//  Scantruckparts-iOS
//
//  Created by Chris Manik on 7/7/20.
//  Copyright © 2020 scantruck. All rights reserved.
//

import UIKit
import Firebase

class CartViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkOut: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var emptyImage: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    
    var cart : [Cart] = []
    var total: Double = 0.0
    let db = Firestore.firestore()
    let currentUser = Auth.auth().currentUser
    
    var message = ""
    var quantityValue = 0.0
    var sku = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: K.cellNibCart, bundle: nil), forCellReuseIdentifier: K.cellIdentifierCart)
        loadProduct()
        
//        self.priceLabel.isHidden = true
//        self.totalLabel.isHidden = true
//
//        self.checkOut.isHidden = true
        bottomView.isHidden = true
        emptyImage.isHidden = true
        
        // Do any additional setup after loading the view.
        
    }
    
    func loadProduct(){
        guard let email = currentUser?.email else{
            return
        }
        db.collection(K.FStore.cartCollection).whereField("email", isEqualTo: email).order(by: K.FStore.Cart.date).addSnapshotListener { (querySnapshot, error) in
            self.cart = []
            self.total = 0.0
            if error == nil {
                if querySnapshot!.isEmpty{
                    self.tableView.isHidden = true
                    self.emptyImage.isHidden = false
                    self.bottomView.isHidden = true
//                    self.emptyImage.layer.cornerRadius = self.emptyImage.frame.size.height/10.0
                }else{
                    self.tableView.isHidden = false
                    self.emptyImage.isHidden = true
                    self.bottomView.isHidden = false
                    for document in querySnapshot!.documents{
                        let cartData = document.data()
                        let id = document.documentID
                        if let sku = cartData[K.FStore.Cart.sku] as? String, let name = cartData[K.FStore.Cart.name] as? String,
                            let price = cartData[K.FStore.Cart.price] as? Double, let qty = cartData[K.FStore.Cart.quantity] as? Int, let img = cartData[K.FStore.Cart.image] as? String{
                            let newCart = Cart(sku: sku, name: name,image: img, price: price, quantity: qty,id: id)
                            
                            self.cart.append(newCart)
                            self.total += newCart.totalPrice
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                self.priceLabel.text = String("SGD \(String(format: "%.2f", self.total))")
                            }
                        }
                    }
                }
                
                
            }else{
                self.message = "Eror to Load Cart"
                self.alertMessage(with: self.message)
            }
        }
    }
    
    
    @IBAction func checkOutPressed(_ sender: UIButton) {
        print(total)
    }
    
    //MARK: - Download and load image from Firebase Storage
    
    func loadImage(with imageChild: String) -> StorageReference{
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let ref = storageRef.child(imageChild)
        
        return ref
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.cartProduct{
            let destinationVC = segue.destination as! ProductDetailController
            destinationVC.hidesBottomBarWhenPushed = true
            destinationVC.skuNumber = sku
        }
    }
    
    //MARK: - Message Alert Controller
    func alertMessage(with message: String){
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
}




extension CartViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifierCart, for: indexPath) as! CartCell
        cell.productLabel.text = cart[indexPath.row].name
        cell.priceLabel.text = String("SGD \(cart[indexPath.row].price)")
        cell.quantityLabel.text = String(cart[indexPath.row].quantity)
        cell.stepper.value = Double(cart[indexPath.row].quantity)
        cell.index = indexPath
        cell.delegate = self
        
        let refImage = loadImage(with: cart[indexPath.row].image)
        cell.productImage.sd_setImage(with: refImage)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sku = cart[indexPath.row].sku
        self.performSegue(withIdentifier: K.cartProduct, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

extension CartViewController: CartCollectionProtocol{
    func deleteData(index: Int) {
        
        db.collection(K.FStore.cartCollection).document(cart[index].id).delete()
        loadProduct()
        //        total = total - cart[index].totalPrice
        //        priceLabel.text = String("SGD \(total)")
        
        //        cart.remove(at: index)
        
        print(cart)
    }
    func updateQty(index: Int, qty: Int) {
        
        db.collection(K.FStore.cartCollection).document(cart[index].id).updateData([K.FStore.Cart.quantity : qty]) { (error) in
            if let e = error{
                self.message = e.localizedDescription
                self.alertMessage(with: self.message)
            }else{
                self.loadProduct()
                print(self.cart[index].quantity)
            }
        }
    }
    
    
}
