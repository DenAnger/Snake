//
//  Snake.swift
//  SnakeGame
//
//  Created by Desktop on 17.08.18.
//  Copyright © 2018 Denis Abramov. All rights reserved.
//

import UIKit
import SpriteKit

class Snake: SKShapeNode {
    
    let moveSpeed = 125.0
    var body = [SnakeBodyPart]()
    var angle: CGFloat = 0.0
    
    convenience init(atPoint point: CGPoint) {
        self.init()
        
        let head = SnakeHead(atPoint: point)
        body.append(head)
        addChild(head)
    }
    
    func addBodyPart() {
        let newBodyPart = SnakeBodyPart(atPoint: CGPoint(x: body[0].position.x,
                                                         y: body[0].position.y))
        body.append(newBodyPart)
        addChild(newBodyPart)
    }
    
    func move() {
        
        guard !body.isEmpty else { return }
        
        let head = body[0]
        moveHead(head)
        
        for index in (0 ..< body.count) where index > 0 {
            let previousBodyPart = body[index - 1]
            let currentBodyPart = body[index]
            moveBodyPart(previousBodyPart, c: currentBodyPart)
        }
    }
    
    func moveHead(_ head: SnakeBodyPart) {
        let dx = CGFloat(moveSpeed) * sin(angle)
        let dy = CGFloat(moveSpeed) * cos(angle)
        let nextPosition = CGPoint(x: head.position.x + dx, y: head.position.y + dy)
        let moveAction = SKAction.move(to: nextPosition, duration: 1.0)
        head.run(moveAction)
    }
    
    func moveBodyPart(_ p: SnakeBodyPart, c: SnakeBodyPart) {
        let moveAction = SKAction.move(to: CGPoint(x: p.position.x,
                                                   y: p.position.y),
                                       duration: 0.1)
        c.run(moveAction)
    }
    
    func moveClockwise() {
        angle += CGFloat(Double.pi/2)
    }
    
    func moveCounterClockwise() {
        angle -= CGFloat(Double.pi/2)
    }
}
