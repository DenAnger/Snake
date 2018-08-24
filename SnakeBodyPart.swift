//
//  SnakeBodyPart.swift
//  SnakeGame
//
//  Created by Desktop on 17.08.18.
//  Copyright © 2018 Denis Abramov. All rights reserved.
//

import UIKit
import SpriteKit

class SnakeBodyPart: SKShapeNode {
    
    let diameter = 10.0
    
    // Инициализация тела змеи
    init (atPoint point: CGPoint){
        super.init()
        
        // Круглый элемент
        path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: CGFloat(diameter), height: CGFloat(diameter))).cgPath
        
        // Цвет рамки, заливки и ширина
        fillColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        strokeColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        lineWidth = 5
        
        // Размещаем элемент
        self.position = point
        
        // Создаем физическое тело
        self.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(diameter - 4), center: CGPoint(x: 5, y:5))
        
        // Может перемещаться в простанстве
        self.physicsBody?.isDynamic = true
        
        // Категория - змея
        self.physicsBody?.categoryBitMask = CollisionCategories.Snake
        
        // Пересекается с границами экрана и яблоком
        self.physicsBody?.contactTestBitMask = CollisionCategories.EdgeBody | CollisionCategories.Apple
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
