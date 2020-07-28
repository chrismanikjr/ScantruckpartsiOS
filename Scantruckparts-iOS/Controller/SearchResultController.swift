//
//  SearchResultController.swift
//  Scantruckparts-iOS
//
//  Created by Chris Manik on 7/25/20.
//  Copyright © 2020 scantruck. All rights reserved.
//

import UIKit
import Firebase

class SearchResultController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notFoundImage: UIImageView!
    
    var searchValuee: String?
    
    
    let db = Firestore.firestore()
    var searchData: [SearchData] = []
    
    var sku = ""
    let searchController = UISearchBar()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notFoundImage.isHidden = true
        tableView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        label.text = searchValuee
   
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.cellSearchResult, bundle: nil), forCellReuseIdentifier: K.cellIdentifierSearchResult)
        setupNavBar()
           loadSearching()
    }
    
    func loadSearching(){
        db.collection(K.FStore.productCollection).whereField("brand", isEqualTo: searchValuee!).addSnapshotListener { (querySnapshot, error) in
            self.searchData = []
            if error == nil{
                if querySnapshot!.isEmpty{
                    print("nothing")
                    self.notFoundImage.isHidden = false
                }else{
                    self.tableView.isHidden = false
                    for document in querySnapshot!.documents{
                        let searchData = document.data()
                        if let sku = searchData[K.FStore.Product.sku] as? String, let name = searchData[K.FStore.Product.name] as? String, let desc = searchData[K.FStore.Product.desc] as? String, let price = searchData[K.FStore.Product.price] as? Double, let img = searchData[K.FStore.Product.img] as? String{
                            let newData = SearchData(sku: sku, desc: desc, name: name, price: price, image: img)
                            self.searchData.append(newData)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
                
            }else{
                let e = error!
                print(e.localizedDescription)
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.searchProduct {
            let destinationVC = segue.destination as! ProductDetailController
            destinationVC.hidesBottomBarWhenPushed = true
            destinationVC.skuNumber = sku
        }
    }
    func setupNavBar(){
        navigationItem.titleView = searchController
        searchController.sizeToFit()
        searchController.delegate = self
        searchController.text = searchValuee
        view.backgroundColor = .white
    }
    
    
}
extension SearchResultController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifierSearchResult, for: indexPath) as! SearchResultCell
        
        cell.nameLabel.text = searchData[indexPath.row].name
        cell.descLabel.text = searchData[indexPath.row].desc
        cell.priceLabel.text = ("SGD \(searchData[indexPath.row].price)")
        
        let refImage = loadImage(with: searchData[indexPath.row].image)
        cell.productImage.sd_setImage(with: refImage)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sku = searchData[indexPath.row].sku
        self.performSegue(withIdentifier: K.searchProduct  , sender: self)
    }
    
    
}
extension SearchResultController: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.navigationController?.popViewController(animated: true)
    }
}

