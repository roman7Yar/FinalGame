//
//  Bonus.swift
//  FinalGame
//
//  Created by Roman Yarmoliuk on 27.02.2023.
//

import SpriteKit

class Bonus {
   
    static func addShield(to node: SKShapeNode) {
        let texture = SKTexture(imageNamed: "shield")
        let size = CGSize(width: 40, height: 40)
        let shield = SKSpriteNode(texture: texture, color: .clear, size: size)
        
        shield.physicsBody = .init(rectangleOf: size)
        shield.physicsBody?.categoryBitMask = BitMask.bonus
        shield.physicsBody?.collisionBitMask = 0
        shield.physicsBody?.affectedByGravity = false

        node.addChild(shield)
    }
    
}
