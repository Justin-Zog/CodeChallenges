//
//  LoginToGamesSegue.swift
//  Casino
//
//  Created by Justin Herzog on 2/29/20.
//  Copyright © 2020 Justin Herzog. All rights reserved.
//

import UIKit

class LoginToGamesSegue: UIStoryboardSegue {

    override func perform() {
        // Assign the source and destination views to local variables
        let loginVCView = self.source.view as UIView
        let gameVCView = self.destination.view as UIView
        // Gets the screen width and height
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        // Specify the initial position of the destination view
        gameVCView.frame = CGRect(x: 0.0, y: screenHeight, width: screenWidth, height: screenHeight)
        // Access the app's key window and insert the destination view above the current view
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(gameVCView, aboveSubview: loginVCView)
        
        // Animate the transition
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            loginVCView.frame = loginVCView.frame.offsetBy(dx: -screenWidth, dy: 0.0)
            gameVCView.frame = gameVCView.frame.offsetBy(dx: -screenWidth, dy: 0.0)
        
               }) { (Finished) -> Void in
                self.source.present(self.destination as UIViewController, animated: false, completion: nil)
           }
        
    }
    
}
