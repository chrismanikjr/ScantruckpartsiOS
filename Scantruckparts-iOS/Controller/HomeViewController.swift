//
//  ViewController.swift
//  Scantruckparts-iOS
//
//  Created by Chris Manik on 6/16/20.
//  Copyright © 2020 scantruck. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class HomeViewController: UIViewController, UISearchBarDelegate {
    
    //    let searchController = UISearchController(searchResultsController: nil)
    
    let searchController = UISearchBar()
    let db = Firestore.firestore()
    
    var product : [HomeNewProduct] = []
    var brand: [HomeBrand] = []
    
    var sku = ""
    var brandValue = ""
    
    @IBOutlet weak var newProductCollection: UICollectionView!
    @IBOutlet weak var brandCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        newProductCollection.register(UINib(nibName: K.collectionNewProduct, bundle: nil), forCellWithReuseIdentifier: K.collectionIdentifierNewProduct)
        

        newProductCollection.delegate = self
        newProductCollection.dataSource = self
        

        brandCollection.register(UINib(nibName: K.collectionBrand, bundle: nil), forCellWithReuseIdentifier: K.collectionIdentifierBrand)
        brandCollection.delegate = self
        brandCollection.dataSource = self
        
        
        setupNavBar()
        loadNewProduct()
        loadBrand()
        
    }
    
    func loadNewProduct(){
        db.collection(K.FStore.productCollection).order(by: K.FStore.Product.date).limit(to: 5).addSnapshotListener { (querySnapshot, error) in
            self.product = []
            if error == nil{
                for document in querySnapshot!.documents{
                    let data = document.data()
                    if let sku = data[K.FStore.Product.sku] as? String, let name = data[K.FStore.Product.name] as? String, let img = data[K.FStore.Product.img] as? String{
                        let newProduct = HomeNewProduct(sku: sku, name: name, image: img)
                        self.product.append(newProduct)
                        
                        DispatchQueue.main.async {
                            self.newProductCollection.reloadData()
                        }
                        
                    }
                }
            }
        }
    }
    
    func loadBrand(){
        db.collection(K.FStore.brandCollection).addSnapshotListener { (querySnapshot, error) in
            self.brand = []
            if error == nil{
                for document in querySnapshot!.documents{
                    let data = document.data()
                    print(data)
                    if let name = data[K.FStore.Brand.brand] as? String, let img = data[K.FStore.Brand.img] as? String{
                        let newBrand = HomeBrand(brand: name, image: img)
                        self.brand.append(newBrand)
                        
                        DispatchQueue.main.async {
                            self.brandCollection.reloadData()
                        }
                    }
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
    
    func setupNavBar(){
        
        let icon  = UIImage(named: "ScaniaLogo")
        let iconImageView = UIImageView(image: icon)
        
        iconImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        iconImageView.contentMode = .scaleAspectFit
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: iconImageView)
        
        navigationItem.titleView = searchController
        searchController.sizeToFit()
        searchController.delegate = self
        searchController.placeholder = "Search a Brand Name"
        
        view.backgroundColor = .white
        //        searchController.hidesNavigationBarDuringPresentation = false
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: K.toSearch, sender: self)
        self.searchController.endEditing(true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.toSearch{
            let destinationVC = segue.destination  as! SearchController
            destinationVC.hidesBottomBarWhenPushed = true
        } else if segue.identifier == K.homeProduct{
            let destnationVC = segue.destination as! ProductDetailController
            destnationVC.skuNumber = sku
            destnationVC.hidesBottomBarWhenPushed = true
        } else if segue.identifier == K.homeToResult{
            let destinationVC = segue.destination as! SearchResultController
            destinationVC.searchValuee = brandValue
            destinationVC.hidesBottomBarWhenPushed = true

            
        }
    }
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.newProductCollection{
            return product.count
        }
        return brand.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.newProductCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.collectionIdentifierNewProduct, for: indexPath) as! NewProductCollectionCell
            cell.nameLabel.text = product[indexPath.row].name
            
            let refImage = loadImage(with: product[indexPath.row].image)
            cell.productImage.sd_setImage(with: refImage)
            return cell
        } else{
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: K.collectionIdentifierBrand, for: indexPath) as! BrandCollectionCell
            let refImage2 = loadImage(with: brand[indexPath.row].image)
            cell2.brandImage.sd_setImage(with: refImage2)
            return cell2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.newProductCollection{
            sku = product[indexPath.row].sku
                   self.performSegue(withIdentifier: K.homeProduct, sender: self)
                   collectionView.deselectItem(at: indexPath, animated: true)
        }else{
            brandValue = brand[indexPath.row].brand
            self.performSegue(withIdentifier: K.homeToResult, sender: self)
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180 , height: 180)
    }
    
    
}

