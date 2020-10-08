//
//  CartViewController.swift
//  Scantruckparts-iOS
//
//  Created by Chris Manik on 7/7/20.
//  Copyright © 2020 scantruck. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class CartViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkOut: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var emptyImage: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    
    var cart : [Cart] = []
    var total: Double = 0.0
    private let db = Firestore.firestore()
    let currentUser = HomeViewController.shared.user
    
    private var timer: Timer?
    private var loading = NVActivityIndicatorView(frame: .zero, type: .ballSpinFadeLoader, color: .blue, padding: 0)
    private var view2 = UIView()
    var message = ""
//    var quantityValue = 0.0
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
        guard let email = currentUser.email else{
            message = "Error to load current user's email"
            alertMessage(with: message)
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
        startLoadingAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.loading.stopAnimating()
            self.view2.isHidden = true
            self.performSegue(withIdentifier: K.checkout, sender: self)
        }
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
        }else{
            let checkOutVC = segue.destination as! CheckOutAddressController
            checkOutVC.hidesBottomBarWhenPushed = true
            checkOutVC.cartList = cart
            checkOutVC.total = total
        }
    }
    
    //MARK: - Message Alert Controller
    func alertMessage(with message: String){
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Animation Loading

    func startLoadingAnimation(){
        loading.translatesAutoresizingMaskIntoConstraints = false
//        loading.backgroundColor = UIColor(red: 52, green: 0, blue: 0, alpha: 1)
//
//        loading.clipsToBounds = true
//        loading.layer.cornerRadius = loading.frame.size.height/3.0
           view2 = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        view2.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.95, alpha: 0.4)
        view.addSubview(view2)
        view.addSubview(loading)
        
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 40),
            loading.heightAnchor.constraint(equalToConstant: 40),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        loading.startAnimating()
        
    }
    
}




extension CartViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifierCart, for: indexPath) as! CartCell
        let refImage = loadImage(with: cart[indexPath.row].image)
        cell.productImage.sd_setImage(with: refImage)
        
        cell.hideAnimation()
        cell.productLabel.text = cart[indexPath.row].name
        cell.priceLabel.text = String("SGD \(cart[indexPath.row].price)")
        cell.quantityLabel.text = String(cart[indexPath.row].quantity)
        cell.stepper.value = Double(cart[indexPath.row].quantity)
        cell.index = indexPath
        cell.delegate = self
        
        
        
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
