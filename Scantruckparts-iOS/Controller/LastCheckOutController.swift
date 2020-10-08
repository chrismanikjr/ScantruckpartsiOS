//
//  LastCheckOutController.swift
//  Scantruckparts-iOS
//
//  Created by Chris Manik on 7/29/20.
//  Copyright © 2020 scantruck. All rights reserved.
//

import UIKit
import Firebase
class LastCheckOutController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var courierTextField: UITextField!
    @IBOutlet weak var paymentTextField: UITextField!
    
    var cartList : [Cart] = []
    private let courierList = ["T&T Express","T& Economy Express","Self Pickup"]
    private let paymentList = ["Credit/Debit Card", "Bank Transfer"]
    
    private var index = 0
    private var indexPay = 0
    
    private var courierPicker = UIPickerView()
    private var paymentPicker = UIPickerView()
    private var view2 =  UIView()

    
    
    var total: Double = 0.0
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Delivery and Payment"
        customElements()
        tableView.dataSource = self
        tableView.delegate = self
        
        courierPicker.dataSource = self
        courierPicker.delegate = self
        paymentPicker.dataSource = self
        paymentPicker.delegate = self
        
        courierTextField.inputView = courierPicker
        paymentTextField.inputView = paymentPicker
        
        // Create Toolbar Done
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.tintColor = UIColor.blue
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(LastCheckOutController.donePressed(sender:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton,doneButton], animated: true)
        
        courierTextField.inputAccessoryView = toolbar
        
        let toolbarPay = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        toolbarPay.barStyle = UIBarStyle.default
        toolbarPay.isTranslucent = true
        toolbarPay.tintColor = UIColor.blue
        let doneButtonPay = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(LastCheckOutController.donePayPressed(sender:)))
        let spaceButtonPay = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbarPay.setItems([spaceButtonPay,doneButtonPay], animated: true)
        paymentTextField.inputAccessoryView = toolbarPay
        
        // Register Table View
        tableView.register(UINib(nibName: K.checkoutProduct, bundle: nil), forCellReuseIdentifier: K.checkoutProductIdentifier)
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
    
    
    
    @objc func donePressed(sender: UIBarButtonItem){
        courierTextField.resignFirstResponder()
        courierTextField.text = courierList[index]
    }
    
    
    @objc func donePayPressed(sender: UIBarButtonItem){
        paymentTextField.resignFirstResponder()
        paymentTextField.text = paymentList[indexPay]
    }
    
    func customElements(){
         Utilities.styleTextField(paymentTextField)
         Utilities.styleTextField(courierTextField)
         
     }
}

extension LastCheckOutController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.checkoutProductIdentifier, for: indexPath) as! CheckoutProductCell
        cell.hideAnimation()
        cell.nameLabel.text = cartList[indexPath.row].name
        cell.priceLabel.text = String("SGD \(cartList[indexPath.row].price)")
        cell.qtyLabel.text = String(cartList[indexPath.row].quantity)
        
        let refImage = loadImage(with: cartList[indexPath.row].image)
        cell.productImage.sd_setImage(with: refImage)
        
        return cell
    }
}

extension LastCheckOutController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.courierPicker{
            return courierList.count
        }else{
            return paymentList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.courierPicker{
            return courierList[row]
        }else{
            return paymentList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.courierPicker{
            index = row
        }else{
            indexPay = row
        }
    }
    
}
