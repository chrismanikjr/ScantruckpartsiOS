//
//  RegisterViewController.swift
//  Scantruckparts-iOS
//
//  Created by Chris Manik on 6/24/20.
//  Copyright © 2020 scantruck. All rights reserved.
//

import UIKit
import Firebase
class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var telephoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    var message: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        customElements()
    }
    
    
    //MARK: - Register User
    @IBAction func registerPressed(_ sender: Any) {
        let error = validateFields()
        if error != nil{
            message = error!
            alertMessage(with: message)
        }
        else{
            if let email = emailTextField.text, let name =  nameTextField.text, let telephone = telephoneTextField.text, let password = passwordTextField.text{
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let e = error{
                        self.message = e.localizedDescription
                        self.alertMessage(with: self.message)
                    }else{
                        let userUID = authResult!.user.uid
                        let db = Firestore.firestore()
                        db.collection(K.FStore.userCollection).document(userUID).setData(["email": email,
                                                                                          "userUID": authResult!.user.uid,
                                                                                          "fullName": name,
                                                                                          "telephoneNumber": telephone]) { (error) in
                                                                                            if error != nil{
                                                                                                self.message =  error!.localizedDescription
                                                                                                self.alertMessage(with: self.message)
                                                                                            }
                        }
                    }
                    self.clearFields()
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
            }
        }
    }
    
    
    @IBAction func loginPressed(_ sender: Any) {
        clearFields()
        navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Validate fields
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    
    func validateFields() -> String?{
        
        // Check that all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || telephoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
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
    
    //MARK: - Clear text field()
    
    func clearFields(){
        emailTextField.text = ""
        passwordTextField.text = ""
        telephoneTextField.text = ""
        nameTextField.text = ""
    }
    
    //MARK: - Custom Button, TextField
    func customElements(){
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(telephoneTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(nameTextField)
        Utilities.customButton(registerButton)
        Utilities.plainButton(loginButton)
    }
}
