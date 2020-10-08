//
//  AccountViewController.swift
//  Scantruckparts-iOS
//
//  Created by Chris Manik on 6/24/20.
//  Copyright © 2020 scantruck. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class AccountViewController: UIViewController {
    @IBOutlet weak var editingLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var telephoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    
    let currentUser = HomeViewController.shared.user
    private  let db = Firestore.firestore()
    let loading = NVActivityIndicatorView(frame: .zero, type: .ballSpinFadeLoader, color: .blue, padding: 0)
    
    var message: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        customElements()
        loadTextField()
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        startAnimation()
        do {
            try Auth.auth().signOut()
            loading.stopAnimating()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            loading.stopAnimating()
            print ("Error signing out: %@", signOutError)
        }

    }
    //MARK: - Load User Info
    
    func loadTextField(){
       
        let docRef = db.collection(K.FStore.userCollection).document(currentUser.uid)
        docRef.addSnapshotListener { (documentSnapshot, error) in
            if let document = documentSnapshot{
                if let data = document.data(){
                    if let emailText = data[K.FStore.emailField] as? String, let fullNameText = data[K.FStore.fullNameField] as? String, let telephoneText = data[K.FStore.telephoneField] as? String{
                        DispatchQueue.main.async {
                            self.emailTextField.text = emailText
                            self.nameTextField.text = fullNameText
                            self.telephoneTextField.text = telephoneText
                        }
                    }
                }
            }
        }

    }
    
    //MARK: - Update user Info
    
    @IBAction func updatePressed(_ sender: Any) {
        startAnimation()
        let error = validateFields()
        if error != nil{
            message = error!
            loading.stopAnimating()
            alertMessage(with: message)
        }else{
            if let name = nameTextField.text, let telephone = telephoneTextField.text,let password = passwordTextField.text{
                currentUser.updatePassword(to: password, completion: { (error) in
                    if let e = error{
                        self.loading.stopAnimating()
                        self.message = e.localizedDescription
                    }else{
                        self.db.collection(K.FStore.userCollection).document(self.currentUser.uid).updateData(["fullName": name,"telephoneNumber": telephone]) { (error) in
                            if let e = error {
                                self.message = e.localizedDescription
                                self.alertMessage(with: self.message)
                            }else{
                                self.message = "Succes Update User Data"
                                self.alertMessage(with: self.message)
                                self.clearFields()
                            }
                            self.loading.stopAnimating()
                        }
                    }
                })
            }
        }
    }
    
    //MARK: - Animation Loading for waiting
    func startAnimation(){
           
           loading.translatesAutoresizingMaskIntoConstraints = false
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
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || telephoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
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
        passwordTextField.text = ""
    }
    
    //MARK: - Custom Button, TextField
    func customElements(){
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(telephoneTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(nameTextField)
        Utilities.customButton(updateButton)
        Utilities.plainButton(logOutButton)
    }
    
}

extension AccountViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    } 
}
