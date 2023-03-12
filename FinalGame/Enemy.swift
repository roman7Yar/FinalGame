//
//  Enemy.swift
//  FinalGame
//
//  Created by Roman Yarmoliuk on 21.02.2023.
//

import SpriteKit

class Enemy {
    
    static func addEnemies(to node: SKShapeNode, level: Level) {
       
        let numberOfEnemies = Int.random(in: level.setup.minEnemies...level.setup.maxEnemies)
        let randomDuration = CGFloat.random(in: level.setup.minDuration...level.setup.maxDuration)
       
        let direction = level.setup.direction
        
        for i in 1...numberOfEnemies {
           
            let enemy = BaseEnemy(bodyRadius: 18, image: UIImage(named: "asteroid1")!, moveRadius: 120)
            enemy.applyCirclePathAction(forPlace: i, duration: randomDuration, direction: direction)
            node.addChild(enemy)
            
            if level.setup.bigEnemy {
                let bigEnemy = BaseEnemy(bodyRadius: 26, image: UIImage(named: "asteroid4")!, moveRadius: 75)
                bigEnemy.applyCirclePathAction(forPlace: i, duration: randomDuration * 1.2, direction: direction)
                node.addChild(bigEnemy)
            }
            
        }
    }
    
}

extension Enemy {
    private class BaseEnemy: SKSpriteNode {
        
        var radius = CGFloat(110)
        
        init(bodyRadius: CGFloat, image: UIImage, moveRadius: CGFloat) {
            
            radius = moveRadius

            let texture = SKTexture(image: image)
            let size = CGSize(width: bodyRadius * 2, height: bodyRadius * 2)
            
            super.init(texture: texture, color: .clear, size: size)
            
            self.physicsBody = SKPhysicsBody(circleOfRadius: bodyRadius)
            self.physicsBody?.categoryBitMask = BitMask.enemy
            self.physicsBody?.collisionBitMask = 0
            self.physicsBody?.affectedByGravity = false
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func applyCirclePathAction(forPlace place: Int, duration: CGFloat, direction: Direction) {
            let bool = Bool.random()
            
            let clockwise = {
                switch direction {
                case .clockwise:
                    return true
                case .counterclockwise:
                    return false
                case .combine:
                    return bool
                }
            }
            
            let size = self.frame.height
            let offsetCoefficient = size / radius
            let startAngle = CGFloat(place) * offsetCoefficient
            let endAngle = clockwise() ? startAngle + .pi * 2 : startAngle - .pi * 2
            
            let circlePath = UIBezierPath(arcCenter: .zero,
                                          radius: radius,
                                          startAngle: startAngle,
                                          endAngle: endAngle,
                                          clockwise: clockwise())
            
            let followCircle = SKAction.follow(circlePath.cgPath,
                                               asOffset: false,
                                               orientToPath: true,
                                               duration: duration)
            
            self.run(.repeatForever(followCircle))
        }
        
    }
        
}

