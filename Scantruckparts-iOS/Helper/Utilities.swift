//
//  Utilities.swift
//  customauth
//
//  Created by Christopher Ching on 2019-05-09.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    //MARK: - custom Text Field
    static func styleTextField(_ textField: UITextField){
        //Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textField.frame.height-2, width: textField.frame.width, height: 2)
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
        button.layer.cornerRadius = button.frame.size.height/2.0
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
    
    
}
