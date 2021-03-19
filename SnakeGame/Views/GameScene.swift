//
//  GameScene.swift
//  SnakeGame
//
//  Created by Desktop on 17.08.18.
//  Copyright © 2018 Denis Abramov. All rights reserved.
//

import SpriteKit
import GameplayKit

struct CollisionCategories {
    static let snake: UInt32 = 0x1 << 0
    static let snakeHead: UInt32 = 0x1 << 1
    static let apple: UInt32 = 0x1 << 2
    
    static let edgeBody: UInt32 = 0x1 << 3
}

class GameScene: SKScene {
    
    var snake: Snake?
    
    override func didMove(to view: SKView) {
        backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.physicsBody?.allowsRotation = false
        view.showsPhysics = true
        self.physicsWorld.contactDelegate = self
        self.physicsBody?.categoryBitMask = CollisionCategories.edgeBody
        self.physicsBody?.collisionBitMask = CollisionCategories.snake | CollisionCategories.snakeHead
        
        // MARK: Counter-clockwise turn
        
        let counterClockwiseButton = SKShapeNode()
        
        counterClockwiseButton.path = UIBezierPath(
            ovalIn: CGRect(x: 0, y: 0, width: 45, height: 45)
        ).cgPath
        
        counterClockwiseButton.position = CGPoint(
            x: view.scene!.frame.minX + 30, y: view.scene!.frame.minY + 30
        )
        
        counterClockwiseButton.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        counterClockwiseButton.strokeColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        counterClockwiseButton.lineWidth = 10
        counterClockwiseButton.name = "counterClockwiseButton"
        
        self.addChild(counterClockwiseButton)
        
        // MARK: Clockwise turn
        
        let clockwiseButton = SKShapeNode()
        
        clockwiseButton.path = UIBezierPath(
            ovalIn: CGRect(x: 0, y: 0, width: 45, height: 45)
        ).cgPath
        
        clockwiseButton.position = CGPoint(
            x: view.scene!.frame.maxX - 80, y: view.scene!.frame.minY + 30
        )
        
        clockwiseButton.fillColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        clockwiseButton.strokeColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        clockwiseButton.lineWidth = 10
        clockwiseButton.name = "clockwiseButton"
        self.addChild(clockwiseButton)
        
        createApple()
        createSnake()
    }
    
    func createSnake() {
        snake?.removeFromParent()
        snake = Snake(atPoint: CGPoint(x: (view?.scene!.frame.midX)!,
                                       y: (view?.scene!.frame.midY)!))
        self.addChild(snake!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let touchLocation = touch.location(in: self)
            
            guard let touchedNode = self.atPoint(touchLocation) as? SKShapeNode,
                touchedNode.name == "counterClockwiseButton" || touchedNode.name == "clockwiseButton" else {
                    return
            }
            touchedNode.fillColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
            
            if touchedNode.name == "counterClockwiseButton" {
                snake!.moveCounterClockwise()
            } else if touchedNode.name == "clockwiseButton" {
                snake!.moveClockwise()
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let touchLocation = touch.location(in: self)
            
            guard let touchedNode = self.atPoint(touchLocation) as? SKShapeNode,
                touchedNode.name == "counterClockwiseButton" || touchedNode.name == "clockwiseButton" else {
                    return
            }
            touchedNode.fillColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
        snake!.move()
    }
    
    func createApple() {
        let randX = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxX - 5)) + 1)
        let randY = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxY - 5)) + 1)
        let apple = Apple(position: CGPoint(x: randX, y: randY))
        
        self.addChild(apple)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func losingAlert(_ message: String) {
        let alert = UIAlertController(title: "Game over!",
                                      message: message,
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "New game?",
                                      style: .destructive,
                                      handler: { (action) in
            self.createSnake()
        }))
        self.view?.window?.rootViewController?.present(alert,
                                                       animated: true,
                                                       completion: nil)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyes = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        let collisionObject = bodyes ^ CollisionCategories.snakeHead
        
        switch collisionObject {
        case CollisionCategories.apple:
            let apple = contact.bodyA.node is Apple ? contact.bodyA.node : contact.bodyB.node
            snake?.addBodyPart()
            apple?.removeFromParent()
            createApple()
        case CollisionCategories.edgeBody:
            losingAlert("Ты умер")
        default:
            break
        }
    }
}
