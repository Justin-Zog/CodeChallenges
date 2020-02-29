//
//  LoginViewController.swift
//  Casino
//
//  Created by Justin Herzog on 2/29/20.
//  Copyright © 2020 Justin Herzog. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Segues to the next view controller if the user sign in is successful
        Auth.auth().addStateDidChangeListener { (auth, user) in
            // If the user exists, user is populated with the user's information
            if user != nil {
                self.performSegue(withIdentifier: "toGameSelection", sender: nil)
                self.emailTextField.text = nil
                self.passwordTextField.text = nil
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        // Gets the email and password from the textfield
        guard let email = emailTextField.text, let password = passwordTextField.text, email.count > 0, password.count > 0 else { return }
        
        // Signs in the user with the given email and password
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error, user == nil {
                let alert = UIAlertController(title: "Sign In Failed", message: error.localizedDescription, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        // Create an alert controller
        let signUpAlert = UIAlertController(title: "Sign Up", message: "Enter your preferred email and password", preferredStyle: .alert)
        
        // Add the email text field
        signUpAlert.addTextField { (textField) in
            textField.placeholder = "Email"
        }
        // Adds the password text field
        signUpAlert.addTextField { (textField) in
            textField.placeholder = "Password"
        }
        
        // Get the values from the textFields
        signUpAlert.addAction(UIAlertAction(title: "Sign Up", style: .default, handler: { _ in
            
            // Gets the email
            guard let emailTextField = signUpAlert.textFields?[0], let email = emailTextField.text else { print("Could not get an email"); return }
            
            // Gets the password
            guard let passwordTextField = signUpAlert.textFields?[1], let password = passwordTextField.text else { print("Could not get a password"); return }
            
            // Creates a new user
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if error == nil {
                    // Authenticates the user by signing them in with the newly created account
                    Auth.auth().signIn(withEmail: email, password: password)
                }
            }
            
        }))
        
        // Present the alert controller
        self.present(signUpAlert, animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
