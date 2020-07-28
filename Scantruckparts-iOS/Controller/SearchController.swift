//
//  SearchResultController.swift
//  Scantruckparts-iOS
//
//  Created by Chris Manik on 7/9/20.
//  Copyright © 2020 scantruck. All rights reserved.
//

import UIKit

class SearchController: UIViewController, UISearchBarDelegate {

    
    @IBOutlet weak var searchController: UISearchBar!
    
    var searchValue = ""

//    @IBOutlet weak var searchController: UISearchController!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        searchController.becomeFirstResponder()

 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false

    }

   
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.delegate = self

        setupSearchBar()
        // Do any additional setup after loading the view.
    }
    

    func setupSearchBar(){
        
        searchController.showsCancelButton = true
        searchController.becomeFirstResponder()
            
    //        searchController.hidesNavigationBarDuringPresentation = false
            
        }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.popViewController(animated: true)

    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let textSearch = searchBar.text{
            searchValue = textSearch
            performSegue(withIdentifier: K.toResult, sender: self)
      

        }
        
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.toResult{
            let destinationVC = segue.destination as! SearchResultController
            destinationVC.searchValuee = searchValue
            
        }
    }
}
