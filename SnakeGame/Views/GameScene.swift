//
//  GameScene.swift
//  SnakeGame
//
//  Created by Desktop on 17.08.18.
//  Copyright © 2018 Denis Abramov. All rights reserved.
//

import SpriteKit
import GameplayKit

// MARK: - Пересечение объектов
struct CollisionCategories {
    static let snake: UInt32 = 0x1 << 0
    static let snakeHead: UInt32 = 0x1 << 1
    static let apple: UInt32 = 0x1 << 2
    
    // Край сцены
    static let edgeBody: UInt32 = 0x1 << 3
}

class GameScene: SKScene {
    
    var snake: Snake?
    
    // MARK: - Запуск сцены
    override func didMove(to view: SKView) {
        
        // Цвет фона
        backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        
        // Вектор и сила гравитации
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        // Поддержка физики
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        // Внешнее воздействие на игру
        self.physicsBody?.allowsRotation = false
        
        // Отображение отладочной информации
        view.showsPhysics = true
        
        // Делает сцену делегатом соприкосновений
        self.physicsWorld.contactDelegate = self
        
        // Устанавливает категорию взаимодействия с другими объектами
        self.physicsBody?.categoryBitMask = CollisionCategories.edgeBody
        
        // Устанавливает категории, с которыми будут пересекаться края сцены
        self.physicsBody?.collisionBitMask = CollisionCategories.snake | CollisionCategories.snakeHead
        
        // MARK: Поворот против часовой стрелке
        
        // Нода (объект)
        let counterClockwiseButton = SKShapeNode()
        
        // Форма круга
        counterClockwiseButton.path = UIBezierPath(
            ovalIn: CGRect(x: 0, y: 0, width: 45, height: 45)
        ).cgPath
        
        // Позиция на экране
        counterClockwiseButton.position = CGPoint(
            x: view.scene!.frame.minX + 30, y: view.scene!.frame.minY + 30
        )
        
        // Цвет заливки
        counterClockwiseButton.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        // Цвет рамки
        counterClockwiseButton.strokeColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        // Толщина рамки
        counterClockwiseButton.lineWidth = 10
        
        // Имя объекта для взаимодействия
        counterClockwiseButton.name = "counterClockwiseButton"
        
        // Добавление на экран
        self.addChild(counterClockwiseButton)
        
        // MARK: Поворот по часовой стрелке
        
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
        
        // Создание объектов
        createApple()
        createSnake()
    }
    
    // MARK: - Создание змеи
    func createSnake() {

        // Вывод в центре экрана
        snake?.removeFromParent()
        snake = Snake(atPoint: CGPoint(x: (view?.scene!.frame.midX)!, y: (view?.scene!.frame.midY)!))
        self.addChild(snake!)
    }
    
    // MARK: - Нажатие на экран
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Перебор всех точек экрана, куда прикоснулся палец
        for touch in touches {
            
            // Координаты прикосновения
            let touchLocation = touch.location(in: self)
            
            // Проверка обьекта
            guard let touchedNode = self.atPoint(touchLocation) as? SKShapeNode,
                touchedNode.name == "counterClockwiseButton" || touchedNode.name == "clockwiseButton" else {
                    return
            }
            
            // Изменение цвета кнопки
            touchedNode.fillColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
            
            // Определят, какая кнопка нажата и поворачивает в нужную сторону
            if touchedNode.name == "counterClockwiseButton" {
                snake!.moveCounterClockwise()
            } else if touchedNode.name == "clockwiseButton" {
                snake!.moveClockwise()
            }
        }
    }
    
    // MARK: - Прекращение нажатия на экран
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Перебор всех точек экрана. Когда палец отрывается от экрана.
        for touch in touches {
            let touchLocation = touch.location(in: self)
            
            guard let touchedNode = self.atPoint(touchLocation) as? SKShapeNode,
                touchedNode.name == "counterClockwiseButton" || touchedNode.name == "clockwiseButton" else {
                    return
            }
            
            // Возвращение цвета кнопке
            touchedNode.fillColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
    // MARK: - Обрыв нажатия на экран
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    // MARK: - Обработка кадров сцены
    override func update(_ currentTime: TimeInterval) {
        // Движение змеи
        snake!.move()
    }
    
    // MARK: - Создание яблока в случайной точке экрана
    func createApple() {
        
        // Случайная точка
        let randX = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxX - 5)) + 1)
        let randY = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxY - 5)) + 1)
        
        let apple = Apple(position: CGPoint(x: randX, y: randY))
        
        // Добавление яблока на экран
        self.addChild(apple)
    }
}

// MARK: - Расширение сцены
extension GameScene: SKPhysicsContactDelegate {
        
    /// Сообщение о пройгрыше с возможностью начать игру заново
    func losingAlert(_ message: String) {
        let alert = UIAlertController(title: "Конец игры!", message: message, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Сначала?", style: .destructive, handler: { (action) in
            self.createSnake()
        }))
        
        self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Отслеживание начала столкновения
    func didBegin(_ contact: SKPhysicsContact) {
        
        // Логическая сумма масок сопрекоснувшихся объектов
        let bodyes = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        // Вычитание из суммы головы змеи и остаётся маска второго объекта
        let collisionObject = bodyes ^ CollisionCategories.snakeHead
        
        // Проверка, что за второй объект
        switch collisionObject {
            
        // Проверка, что это яблоко
        case CollisionCategories.apple:
            
            // Яблоко это один из двух объектов
            let apple = contact.bodyA.node is Apple ? contact.bodyA.node : contact.bodyB.node
            
            // Добавляем к змее еще одну секцию
            snake?.addBodyPart()
            
            // Удаляет яблоко
            apple?.removeFromParent()
            
            // Создаёт новое яблоко
            createApple()
            
        // Соприкосновение со стенкой экрана
        case CollisionCategories.edgeBody:
            losingAlert("Ты умер")
        default:
            break
        }
    }
}
