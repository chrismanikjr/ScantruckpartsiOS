//
//  ProductDetailController.swift
//  Scantruckparts-iOS
//
//  Created by Chris Manik on 7/9/20.
//  Copyright © 2020 scantruck. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseUI
import SkeletonView
import NVActivityIndicatorView

class ProductDetailController: UIViewController {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var widthLabel: UILabel!
    
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var addCart: UIButton!
    
    
    private let db = Firestore.firestore()
    var searchController = UISearchBar()
    
    private let loading = NVActivityIndicatorView(frame: .zero, type: .ballSpinFadeLoader, color: .blue, padding: 0)
    private var view2 = UIView()
    
    var skuNumber: String?
    private var product: [Products] = []
    private var productShip : [Products.ShippingDetails] = []
    
    private var qtyValue: Double = 1.0
    private var qtyMax: Double = 1.0
    
    private var priceValue: Double = 0.0
    private var imagePath = ""
    
    private var message = ""

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBottomBarWhenPushed = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBottomBarWhenPushed = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        startLoadingAnimation()
        searchController.delegate = self
        
        loadProduct()
//        disableButton()
    }
    
    //MARK: - Take Product Detail from Product Collection
    func loadProduct(){
        let cartRef = db.collection(K.FStore.productCollection).document(skuNumber!)
        cartRef.getDocument { (documentSnapshot, error) in
            self.product = []
            self.productShip = []
            if let e = error{
                print(e.localizedDescription)
            }else{
                if let doc = documentSnapshot{
                    if let productData = doc.data(){
                        if let skuNumber = productData[K.FStore.Product.sku] as? String, let name = productData[K.FStore.Product.name] as? String, let price = productData[K.FStore.Product.price] as? Double,let qty = productData[K.FStore.Product.qty] as? Int, let img = productData[K.FStore.Product.img] as? String, let desc = productData[K.FStore.Product.desc] as? String,let brand = productData[K.FStore.Product.brand] as? String, let ship = productData[K.FStore.Product.ship] as? [String:Any]{
                            if let wei = ship[K.FStore.Product.weight] as? Double, let len = ship[K.FStore.Product.length] as? Double, let hei = ship[K.FStore.Product.height] as? Double, let wid = ship[K.FStore.Product.width] as? Double{
                                let newShip = Products.ShippingDetails(weight: wei, length: len, height: hei, width: wid)
                                self.productShip.append(newShip)
                            }
                            let newProd = Products(sku: skuNumber, name: name, price: price, quantity: qty, image: img, description: desc, shipping_details: self.productShip, brand: brand)
                            self.product.append(newProd)
                            DispatchQueue.main.async {
                                
                                self.hideLoadingAnimation()
                                
                                let shipping = self.product[0].shipping_details
                                self.nameLabel.text = self.product[0].name
                                self.priceLabel.text = "SGD \(self.product[0].price)"
                                self.descLabel.text = self.product[0].description
                                self.weightLabel.text = "\(shipping[0].weight) kg"
                                self.lengthLabel.text = "\(shipping[0].length) mm"
                                self.heightLabel.text = "\(shipping[0].height) mm"
                                self.widthLabel.text = "\(shipping[0].width) mm"
                                self.priceValue = self.product[0].price
                                
                                self.searchController.placeholder = self.product[0].brand
                                
                                var status: String{
                                    let qtyProd = self.product[0].quantity
                                    switch qtyProd {
                                    case _ where qtyProd > 0:
                                        return "Available"
                                    default:
                                        return "No Stock"
                                    }
                                }
                                self.checkStatusStock(status)
                                
                                self.qtyMax = Double(self.product[0].quantity)
                                self.imagePath = self.product[0].image
                                self.loadImage(with: self.imagePath)
                            }
                        }
                    }
                }
            }
        }
    }

    func setupNavBar(){
        navigationItem.titleView = searchController
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: #selector(popToPrevious)
        )
    }
    
    @objc private func popToPrevious() {
        // our custom stuff
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Download and load image from Firebase Storage
    
    func loadImage(with imageChild: String){
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let ref = storageRef.child(imageChild)
        productImage.sd_setImage(with: ref)
    }
    
    
    @IBAction func qtyStepper(_ sender: UIStepper) {
        qtyValue = sender.value
        sender.maximumValue = qtyMax
        quantityLabel.text = String(format: "%.0f", qtyValue)
    }
    
    //MARK: - Loading Animation
    func startLoadingAnimation(){
        productImage.showAnimatedGradientSkeleton()
        nameLabel.showAnimatedGradientSkeleton()
        priceLabel.showAnimatedGradientSkeleton()
        descLabel.showAnimatedGradientSkeleton()
        weightLabel.showAnimatedGradientSkeleton()
        lengthLabel.showAnimatedGradientSkeleton()
        heightLabel.showAnimatedGradientSkeleton()
        widthLabel.showAnimatedGradientSkeleton()
        statusLabel.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: UIColor(named: "Color-Orange")!))
        quantityLabel.showAnimatedGradientSkeleton()
    }
    func hideLoadingAnimation(){
        productImage.hideSkeleton()
        nameLabel.hideSkeleton()
        priceLabel.hideSkeleton()
        descLabel.hideSkeleton()
        weightLabel.hideSkeleton()
        lengthLabel.hideSkeleton()
        heightLabel.hideSkeleton()
        widthLabel.hideSkeleton()
        statusLabel.hideSkeleton()
        quantityLabel.hideSkeleton()
    }

    func startAnimationLoading(){
        loading.translatesAutoresizingMaskIntoConstraints = false
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
    //MARK: - Check stock Status

    func checkStatusStock(_ status: String){
        switch status {
        case "Available":
            addCart.isEnabled = true
            stepper.isEnabled = true
            statusLabel.text = status
            statusLabel.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        default:
            addCart.isEnabled = false
            stepper.isEnabled = false
            statusLabel.text = status
            statusLabel.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
    }
    //MARK: - Add Product to Cart
    @IBAction func addToCartPressed(_ sender: UIButton) {
        startAnimationLoading()
        let emailUser = Auth.auth().currentUser!.email!
        let docRef = db.collection(K.FStore.cartCollection).whereField(K.FStore.Cart.email, isEqualTo: emailUser).whereField(K.FStore.Cart.sku, isEqualTo: skuNumber!)
        
        //MARK: - Check if product already in Cart
        docRef.getDocuments { (querySnapshot, error) in
            if querySnapshot!.isEmpty{
                if  let sku = self.skuNumber, let name = self.nameLabel.text{
                    self.db.collection(K.FStore.cartCollection)
                        .addDocument(data: [K.FStore.Cart.email: emailUser,
                                            K.FStore.Cart.sku: sku,
                                            K.FStore.Cart.name: name,
                                            K.FStore.Cart.price: self.priceValue,
                                            K.FStore.Cart.quantity: self.qtyValue,
                                            K.FStore.Cart.image: self.imagePath,
                                            K.FStore.Cart.date: Date().timeIntervalSince1970]){
                                                (error) in
                                                if let e = error{
                                                    self.message = e.localizedDescription
                                                    self.alertMessage(with: self.message)
                                                }else{
                                                    self.message = "Product added successfully"
                                                    self.alertMessage(with: self.message)
                                                }
                    }
                }
            }else{
                //MARK: - Adding Cart Quantity with quantity product
                for doc in querySnapshot!.documents{
                    let data = doc.data()
                    let id = doc.documentID
                    if let quantity = data[K.FStore.Cart.quantity] as? Double{
                        self.db.collection(K.FStore.cartCollection).document(id).updateData([K.FStore.Cart.quantity : quantity + self.qtyValue]) { (error) in
                            self.loading.stopAnimating()
                            if let e = error{
                                self.message = e.localizedDescription
                                self.alertMessage(with: self.message)
                            }else{
                                self.message = "Product added successfully"
                                self.alertMessage(with: self.message)
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Message Alert Controller
    func alertMessage(with message: String){
        loading.stopAnimating()
        view2.isHidden = true
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension ProductDetailController: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "productToSearch", sender: self)
    }
}


