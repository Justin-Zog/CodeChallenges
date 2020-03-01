//
//  GameSelectionViewController.swift
//  Casino
//
//  Created by Justin Herzog on 2/29/20.
//  Copyright © 2020 Justin Herzog. All rights reserved.
//

import UIKit
import Firebase

class GameSelectionViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    
    var ref: DatabaseReference! = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Gets the user from firebase
        Auth.auth().addStateDidChangeListener { (auth, user) in
            guard let user = user else { return }
            let uid = user.uid
            self.ref.child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                guard let username = value?["username"] as? String else { print("Failed to get username"); return }
                
                if username != "" {
                    self.usernameLabel.text = ("Welcome " + username)
                }
                
                /*
                   this is how you would get the other results of the user, but we don't need them in this controller
                let email = value?["email"] as? String ?? ""
                let uid = value?["uid"] as? String ?? ""
                */
                
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        // Get the currentUser and their unique id (uid)
        let user = Auth.auth().currentUser!
        let onlineRef = Database.database().reference(withPath: "online/\(user.uid)")
        // Tells firebase this user is no longer online
        onlineRef.removeValue { (error, _) in
            // If there is an error tell me
            if let error = error {
                print("Failed to remove user's online status with error: \(error)")
                return
            }
            
            // Trys to sign the user out and dismisses the view controller if it does, otherwise print an error
            do {
                try Auth.auth().signOut()
                self.navigationController?.popViewController(animated: true)
            } catch (let error) {
                print("Auth sign out failed: \(error)")
            }
        }
    }
    
    @IBAction func blackJackButtonTapped(_ sender: Any) {
        // This automatically segues to the black jack game because you control dragged the segue from the button to the view.  This function isn't even really needed, the only reason this would come in handy is if you needed to push some data to the next controller.
        
        
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
