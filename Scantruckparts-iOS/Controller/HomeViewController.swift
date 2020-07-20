//
//  ViewController.swift
//  Scantruckparts-iOS
//
//  Created by Chris Manik on 6/16/20.
//  Copyright © 2020 scantruck. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

//    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupNavBar()
    }
    
    func setupNavBar(){
        
        let icon  = UIImage(named: "ScaniaLogo")
        let iconImageView = UIImageView(image: icon)
        
        iconImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        iconImageView.contentMode = .scaleAspectFit
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: iconImageView)
        
        let searchController = UISearchController(searchResultsController: nil)
//            navigationItem.searchController = searchController
//        searchController.searchBar.sizeToFit()
        navigationItem.titleView = searchController.searchBar
//        searchController.hidesNavigationBarDuringPresentation = false
        
    }
    @IBAction func searchPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSearchResult", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSearchResult"{
            let destinationVC = segue.destination  as! SearchResultController
            destinationVC.searchPlaceHorder = "Wabco"
            destinationVC.hidesBottomBarWhenPushed = true
            
        }
    }
    
}

