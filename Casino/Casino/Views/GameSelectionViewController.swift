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

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
