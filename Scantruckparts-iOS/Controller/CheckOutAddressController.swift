//
//  CheckOutController.swift
//  Scantruckparts-iOS
//
//  Created by Chris Manik on 7/28/20.
//  Copyright © 2020 scantruck. All rights reserved.
//

import UIKit
import Firebase

class CheckOutAddressController: UIViewController {
    
    var cartList : [Cart] = []
    var total: Double = 0.0
    let db = Firestore.firestore()
    let currentUser = HomeViewController.shared.user
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var zipField: UITextField!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customElemets()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: K.checkoutProduct, bundle: nil), forCellReuseIdentifier: K.checkoutProductIdentifier)
        
        priceLabel.text = String("SGD \(total)")
//        nextButton.isUserInteractionEnabled = false
        
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        performSegue(withIdentifier: K.lastCheckout, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.lastCheckout{
            let destinationVC = segue.destination as! LastCheckOutController
            destinationVC.hidesBottomBarWhenPushed = true
            destinationVC.cartList = cartList
            destinationVC.total = total
        }
    }
    
    //MARK: - Download and load image from Firebase Storage
    
    func loadImage(with imageChild: String) -> StorageReference{
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let ref = storageRef.child(imageChild)
        
        return ref
        
    }
    //MARK: - Custom element
    func customElemets(){
        Utilities.styleTextField(nameField)
        Utilities.styleTextField(addressField)
        Utilities.styleTextField(cityField)
        Utilities.styleTextField(countryField)
        Utilities.styleTextField(zipField)
        Utilities.styleTextField(phoneField)
    }
    
    
    //MARK: - Message Alert Controller
    func alertMessage(with message: String){
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
extension CheckOutAddressController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.checkoutProductIdentifier, for: indexPath) as! CheckoutProductCell
        cell.nameLabel.text = cartList[indexPath.row].name
        cell.priceLabel.text = String("SGD \(cartList[indexPath.row].price)")
        cell.qtyLabel.text = String(cartList[indexPath.row].quantity)
        
        let refImage = loadImage(with: cartList[indexPath.row].image)
        cell.productImage.sd_setImage(with: refImage)
        
        return cell
    }
    
    
    
    
}


