//
//  Utilities.swift
//  customauth
//
//  Created by Christopher Ching on 2019-05-09.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import NVActivityIndicatorView

class Utilities {
    
    //MARK: - custom Text Field
    static func styleTextField(_ textField: UITextField){
        //Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 2, width: textField.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 223/255, green: 230/255, blue: 233/255, alpha: 1).cgColor
        
        // Font
        textField.font = UIFont(name: "Times New Roman", size: 18)
        
        // Remova border on text field
        textField.borderStyle = .none
        
        // Add the line to the text field
        textField.layer.addSublayer(bottomLine)
    }
    
    //MARK: - custom button
    
    static func customButton(_ button: UIButton){
        button.clipsToBounds = true
        button.layer.cornerRadius = button.frame.size.height/5.0   
        button.backgroundColor = UIColor.init(red: 243/255, green: 175/255, blue: 34/255, alpha: 1)
        button.titleLabel?.font = UIFont(name: "Times New Roman", size: 20)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.tintColor = UIColor.systemBlue
    }
    
    static func plainButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.tintColor = UIColor.systemBlue
        button.titleLabel?.font = UIFont(name: "Times New Roman", size: 20)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    //MARK: - Password validation
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func loadImage(with imageChild: String) -> StorageReference{
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let ref = storageRef.child(imageChild)
        return ref
    }
    
//    static func startAnimation(){
//        loading.translatesAutoresizingMaskIntoConstraints = false
////        loading.backgroundColor = UIColor(red: 52, green: 0, blue: 0, alpha: 1)
////
////        loading.clipsToBounds = true
////        loading.layer.cornerRadius = loading.frame.size.height/3.0
//           view2 = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
//        view2.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.95, alpha: 0.4)
//        view.addSubview(view2)
//        view.addSubview(loading)
//        
//        NSLayoutConstraint.activate([
//            loading.widthAnchor.constraint(equalToConstant: 40),
//            loading.heightAnchor.constraint(equalToConstant: 40),
//            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//        ])
//        loading.startAnimating()
//        
//    }
    
    
    
}
