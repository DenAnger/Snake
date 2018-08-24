//
//  GameViewController.swift
//  SnakeGame
//
//  Created by Desktop on 17.08.18.
//  Copyright © 2018 Denis Abramov. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Экземпляр сцены
        let scene = GameScene(size: view.bounds.size)
        
        /// Главная обрасть экрана
        let skView = view as! SKView
        
        // Оторажение FPS
        skView.showsFPS = true
        
        // Количество объектов на экране
        skView.showsNodeCount = true
        
        skView.ignoresSiblingOrder = true
        
        // Растянуть на весь экран
        scene.scaleMode = .resizeFill
        
        // Выводим на экран
        skView.presentScene(scene)
    }
}
