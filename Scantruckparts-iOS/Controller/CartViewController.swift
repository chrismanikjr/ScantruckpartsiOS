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
    
    var cart : [Cart] = []
    var cartProduct : [CartProduct] = []
    let db = Firestore.firestore()
    let currentUser = Auth.auth().currentUser
    
    var message = ""
    var quantityValue = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hidesBottomBarWhenPushed = false
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: K.cellNibCart, bundle: nil), forCellReuseIdentifier: K.cellIdentifierCart)
        loadProduct()
        // Do any additional setup after loading the view.
    }
    

    func loadProduct(){
        
        cart = []
        cartProduct = []
        guard let userUID = currentUser?.uid else{
               return
           }
        let cartRef = db.collection(K.FStore.cartCollection).document(userUID)
        
        cartRef.addSnapshotListener { (documentSnapshot, error) in
            if let document = documentSnapshot{
                if let productCart = document.data()?[K.FStore.Cart.productCart] as? [[String:Any]], let totalPriceCart = document.data()?[K.FStore.Cart.totalPrice] as? Double{
                    for data in productCart{
                        if let sku = data[K.FStore.Cart.sku] as? String, let name = data[K.FStore.Cart.name] as? String, let price = data[K.FStore.Cart.price] as? Double, let quantity = data[K.FStore.Cart.quantity] as? Int, let image = data[K.FStore.Cart.image] as? String{
                            let newProduct = CartProduct(sku: sku, name: name, price: price, quantity: quantity, image: image)
                            self.cartProduct.append(newProduct)
                        }
                    }
                    
                    let newCart = Cart(userUID: userUID, totalPrice: totalPriceCart, productCart: self.cartProduct)
                    self.cart.append(newCart)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.priceLabel.text = String("SGD \(self.cart[0].totalPrice)")
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
    
    

    @IBAction func checkOutPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "cartToProduct", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "cartToProduct"{
               let destinationVC = segue.destination as! ProductDetailController
            destinationVC.hidesBottomBarWhenPushed = true
           }
       }
    //MARK: - Message Alert Controller
    func alertMessage(with message: String){
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}




extension CartViewController: UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifierCart, for: indexPath) as! CartCell
        cell.productLabel.text = cartProduct[indexPath.row].name
        cell.priceLabel.text = String("SGD \(cartProduct[indexPath.row].price)")
        cell.quantityLabel.text = String(cartProduct[indexPath.row].quantity)
        cell.stepper.value = Double(cartProduct[indexPath.row].quantity)
        return cell
    }
    
    
}
