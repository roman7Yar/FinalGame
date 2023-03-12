//
//  OverNode.swift
//  FinalGame
//
//  Created by Roman Yarmoliuk on 25.02.2023.
//

import SpriteKit

class OverNode: SKNode {
    
    let tappedCallBack: () -> ()
    
    init(size: CGSize, score: Int, tappedCallBack: @escaping () -> ()) {
        self.tappedCallBack = tappedCallBack
        
        super.init()
        
        self.zPosition = 100
        self.isUserInteractionEnabled = true
        
        let overLayer = SKShapeNode(rectOf: size)
        overLayer.fillColor = .black.withAlphaComponent(0.5)
        overLayer.lineWidth = 0
        
        
        let scoreText = "Your score: \(score)"
        let scoreLabel = SKLabelNode(text: scoreText)
        
        let bestScoreText = "Best score: \(UserDefaultsManager.shared.score)"
        let bestScoreLabel = SKLabelNode(text: bestScoreText)
        bestScoreLabel.position.y = frame.midY + size.height / 4
        
        let tapLabel = SKLabelNode(text: "TAP TO RESTART")
        tapLabel.fontSize = 22
        tapLabel.position.y -= size.height / 2 - 64 - tapLabel.frame.height
        let action = SKAction.sequence([
            .scale(to: 1.2, duration: 1),
            .scale(to: 1.0, duration: 1),
        ])
        tapLabel.run(.repeatForever(action))
        
        [overLayer, bestScoreLabel, scoreLabel, tapLabel].forEach {
            self.addChild($0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tappedCallBack()
    }
}

