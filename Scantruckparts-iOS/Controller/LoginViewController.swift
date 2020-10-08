//
//  ViewController.swift
//  Scantruckparts-iOS
//
//  Created by Chris Manik on 6/18/20.
//  Copyright © 2020 scantruck. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class LoginViewController: UIViewController{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    private let loading = NVActivityIndicatorView(frame: .zero, type: .ballSpinFadeLoader, color: .blue, padding: 0)
  
    private var view2 =  UIView()
    
    var message = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        customElements()
    }
    @IBAction func loginPressed(_ sender: UIButton) {
        startAnimation()
        let error = validateFields()
        
        if error != nil{
            message = error!
            loading.stopAnimating()
            alertMessage(with: message)
        }else{
            if let email = emailTextField.text ,let password = passwordTextField.text{
                Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
                    if let e = error{
                        self.loading.stopAnimating()
                        self.view2.isHidden = true
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
    
    func startAnimation(){
        loading.translatesAutoresizingMaskIntoConstraints = false
//        loading.backgroundColor = UIColor(red: 52, green: 0, blue: 0, alpha: 1)
//
//        loading.clipsToBounds = true
//        loading.layer.cornerRadius = loading.frame.size.height/3.0
           view2 = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        view2.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.95, alpha: 0.4)
        view.addSubview(view2)
        view.addSubview(loading)
        
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 40),
            loading.heightAnchor.constraint(equalToConstant: 40),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        loading.startAnimating()
        
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
        loading.stopAnimating()
        self.view2.isHidden = true

        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    func customElements(){
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.customButton(loginButton)
        Utilities.plainButton(signUpButton)
//        stackView.clipsToBounds = true
//        stackView.layer.cornerRadius = stackView.frame.size.height/20.0
    }
    
    
}



//MARK: - Text Field Delegate
extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField{
            passwordTextField.resignFirstResponder()
            loginButton.becomeFirstResponder()
        }
        return true
    }
}
