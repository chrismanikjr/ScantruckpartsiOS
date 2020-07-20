//
//  ViewController.swift
//  Scantruckparts-iOS
//
//  Created by Chris Manik on 6/18/20.
//  Copyright © 2020 scantruck. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    var message = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        customElements()
    }
    @IBAction func loginPressed(_ sender: UIButton) {
        let error = validateFields()
        
        if error != nil{
            message = error!
            alertMessage(with: message)
        }else{
            if let email = emailTextField.text ,let password = passwordTextField.text{
                Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
                    if let e = error{
                        self.message = e.localizedDescription
                        self.alertMessage(with: self.message)
                    }else{
                        self.clearFields()
                        self.performSegue(withIdentifier: K.loginSegue, sender: self)
                    }
                }
            }
        }
    }
    
    
    
    //MARK: - Validate fields
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    
    func validateFields() -> String?{
        
        // Check that all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        
        //Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword) == false{
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        return nil
    }
    
    
    //MARK: - Message Alert Controller
    func alertMessage(with message: String){
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    //MARK: - Clear Field
    func clearFields(){
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    func customElements(){
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.customButton(loginButton)
        Utilities.plainButton(signUpButton)
    }
    
    
}

