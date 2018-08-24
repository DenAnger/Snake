//
//  Snake.swift
//  SnakeGame
//
//  Created by Desktop on 17.08.18.
//  Copyright © 2018 Denis Abramov. All rights reserved.
//

import UIKit
import SpriteKit

/// Змея
class Snake: SKShapeNode {
    
    /// Скорость перемещения
    let moveSpeed = 125.0
    
    /// Угол необходимый для расчета направления
    var angle: CGFloat = 0.0
    
    /// Массив где хранятся части змеи
    var body = [SnakeBodyPart]()
    
    // Инициализатор
    convenience init(atPoint point: CGPoint) {
        self.init()
        
        /// Змея начинается с головы, создадим ее
        let head = SnakeHead(atPoint: point)
        
        // ... добавим в массив
        body.append(head)
        
        // ... и сделаем ее дочерним объектом.
        addChild(head)
    }
    
    /// Добавление элемента к змее
    func addBodyPart() {
        
        /// Создаём объект куска тела
        let newBodyPart = SnakeBodyPart(atPoint: CGPoint(x: body[0].position.x, y: body[0].position.y))
        
        // Добавляем его в массив (в змею)
        body.append(newBodyPart)
        
        // Делаем дочерним объектом
        addChild(newBodyPart)
    }
    
    /// Перемещение
    func move(){
        
        // Если у змейки нет головы то ничего не перемещаем
        guard !body.isEmpty else { return }
        
        /// Голова змеи
        let head = body[0]
        
        // Перемещаем голову
        moveHead(head)
        
        // Перемещаем все сегменты тела вслед за головой
        for index in (0..<body.count) where index > 0 {
            let previousBodyPart = body[index-1]
            let currentBodyPart = body[index]
            moveBodyPart(previousBodyPart, c: currentBodyPart)
        }
    }
    
    /// Перемещаем голову
    func moveHead(_ head: SnakeBodyPart){
        
        /// Расчитываем смещение точки по горизонтали
        let dx = CGFloat(moveSpeed) * sin(angle);
        
        /// Расчитываем смещение точки по вертикали
        let dy = CGFloat(moveSpeed) * cos(angle);
        
        /// Смещаем точку назначения головы
        let nextPosition = CGPoint(x: head.position.x + dx, y: head.position.y + dy)
        
        /// Процесс перемещения головы
        let moveAction = SKAction.move(to: nextPosition, duration: 1.0)
        
        // Перемещаем голову
        head.run(moveAction)
    }
    
    /// Перемещаем сегменты змеи
    func moveBodyPart(_ p: SnakeBodyPart, c: SnakeBodyPart){
        
        /// Перемещаем текущий элемент к предыдущему
        let moveAction = SKAction.move(to: CGPoint(x: p.position.x, y: p.position.y), duration: 0.1 )
        // Процесс перемещения
        c.run(moveAction)
    }
    
    /// Поворот по часовой стрелке
    func moveClockwise(){
        // Смещаем угол на 45 градусов
        angle += CGFloat(Double.pi/2)
    }
    
    /// Поворот против часовой стрелки
    func moveCounterClockwise(){
        angle -= CGFloat(Double.pi/2)
    }
}
