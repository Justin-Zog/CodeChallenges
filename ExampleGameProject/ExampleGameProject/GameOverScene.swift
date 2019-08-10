//
//  GameOverScene.swift
//  ExampleGameProject
//
//  Created by Justin Herzog on 8/9/19.
//  Copyright © 2019 Justin Herzog. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    init(size: CGSize, won:Bool) {
        super.init(size: size)
        
        // Sets the background color
        backgroundColor = SKColor.white
        
        // Terinary Operator, if won = true "You Won!" if won = false "You Lose :["
        let message = won ? "You Won!" : "You Lose :["
        
        // This is how you display a label of text on the screen with SpriteKit. As you can see, it's pretty easy. You just choose your font and set a few parameters.
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        // Finally, this sets up and runs a sequence of two actions. First it waits for 3 seconds, then it uses the run() action to run some arbitrary code.
        run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run() { [weak self] in
                // This is how you transition to a new scene in SpriteKit. You can pick from a variety of different animated transitions for how you want the scenes to display. Here you've chosen a flip transition that takes 0.5 seconds. Then you create the scene you want to display, and use presentScene(_:transition:) on self.view.
                guard let `self` = self else { return }
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition:reveal)
            }
            ]))
    }
    
    // If you override an initializer on a scene, you must implement the required init(coder:) initializer as well. However this initializer will never be called, so you just add a dummy implementation with a fatalError(_:) for now
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
