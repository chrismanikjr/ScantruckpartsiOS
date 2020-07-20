//
//  ProductDetailController.swift
//  Scantruckparts-iOS
//
//  Created by Chris Manik on 7/9/20.
//  Copyright © 2020 scantruck. All rights reserved.
//

import UIKit

class ProductDetailController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        // Do any additional setup after loading the view.
    }
    
     func setupNavBar(){
            self.hidesBottomBarWhenPushed = false

        
            
            let searchController = UISearchController(searchResultsController: nil)
    //            navigationItem.searchController = searchController
    //        searchController.searchBar.sizeToFit()
            navigationItem.titleView = searchController.searchBar
        self.hidesBottomBarWhenPushed = true
    //        searchController.hidesNavigationBarDuringPresentation = false
            
        }

}
