//
//  SearchResultController.swift
//  Scantruckparts-iOS
//
//  Created by Chris Manik on 7/9/20.
//  Copyright © 2020 scantruck. All rights reserved.
//

import UIKit

class SearchResultController: UIViewController {

    @IBOutlet weak var searchController: UISearchController!

    var searchPlaceHorder: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        // Do any additional setup after loading the view.
    }
    

    func setupNavBar(){
            
           
            
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.text = searchPlaceHorder
//        searchController.searchBar.showsCancelButton = true
    //            navigationItem.searchController = searchController
    //        searchController.searchBar.sizeToFit()
            navigationItem.titleView = searchController.searchBar
    //        searchController.hidesNavigationBarDuringPresentation = false
            
        }

}
