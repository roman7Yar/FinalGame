//
//  GameScene.swift
//  FinalGame
//
//  Created by Roman Yarmoliuk on 21.02.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var restartCallBack: (() -> ())?
    
    let stationsSetter = StationsSetter()
    
    var player = Player()
  
    var levelLabel: SKLabelNode = {
        var label = SKLabelNode()
        label.fontSize = 50
        label.fontColor = .white
        label.text = "Level 1"
        return label
    }()
   
    let cam = SKCameraNode()
    
    var currentLevel = Level.level1

    override func didMove(to view: SKView) {
     
        backgroundColor = .black
        physicsWorld.contactDelegate = self

        self.camera = cam

        let firstStation = stationsSetter.createFirstStation()
        addChild(firstStation)
        
        levelLabel.position.x = firstStation.position.x
        levelLabel.position.y = firstStation.frame.maxY + 20
        
        addChild(cam)
        addChild(levelLabel)
        addChild(player)
       
        player.position = .zero
        
        player.playerLandedCallBack = {
            self.updateLevel()
            self.stationsSetter.createStation(on: self, currentLevel: self.currentLevel)
            self.removeAsteroids()

            let xPoint = (self.player.position.x + StationsSetter.arrOfPoints.first!.x) / 2
            let yPoint = self.player.position.y + 200
            self.cam.run(.move(to: CGPoint(x: xPoint, y: yPoint), duration: 0.3))
        }
        
        StationsSetter.arrOfPoints = [.zero]

        for _ in 1...2 {
            stationsSetter.createStation(on: self, currentLevel: currentLevel)
        }
        
        StationsSetter.arrOfPoints.removeFirst()
        player.rotate()
        
        cam.position.x = (player.position.x + StationsSetter.arrOfPoints.first!.x) / 2
        cam.position.y = player.position.y + 200
       
        clearNodes()
        player.bonusCallBack?()
        player.playerEmitter?.targetNode = self
        SoundManager.shared.playBackgroundMusic(filename: .spaceBG)
    }
    
    
    func updateLevel() {
        let level = {
            switch player.score {
            case -1...5:
                return Level.level1
            case 6...15:
                return Level.level2
            case 16...30:
                return Level.level3
            case 31...40:
                return Level.level4
            case 41...55:
                return Level.level5
            default:
                return Level.infinity
            }
        }()
       
        if currentLevel != level {
          
            currentLevel = level
            
            let levelLabelCopy = levelLabel.copy() as! SKLabelNode
            
            levelLabelCopy.text = currentLevel.rawValue
            
            levelLabelCopy.position.x = StationsSetter.arrOfPoints.last!.x
            levelLabelCopy.position.y = StationsSetter.arrOfPoints.last!.y - 120//station.frame.height
            
            addChild(levelLabelCopy)
            
        }
    }
   
    func clearNodes() {
        let action = SKAction.run {
            for node in self.children {
                if node.position.y < self.player.position.y - 300 {
                    node.removeFromParent()
                }
            }
        }
        let sqns = SKAction.sequence([.wait(forDuration: 0.5), action])
        self.run(.repeatForever(sqns))
    }
    
    func removeAsteroids() {
        let nodes = scene!.nodes(at: player.position)
        let i = currentLevel == .infinity ? 2 : 1
        var count = 0
        nodes.forEach { node in
            guard node.name == "station" else { return }
            node.children.forEach { asteroid in
                count += 1
                if asteroid.physicsBody?.categoryBitMask == BitMask.bonus {
                    asteroid.removeFromParent()
                }
                if count % i == 0 {
                    asteroid.physicsBody = nil
                    asteroid.run(.scale(to: .zero, duration: 0.3)) {
                        asteroid.removeFromParent()
                    }
                }
            }
        }

    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard player.status == .arrivedOnStation || player.status == .arrivedBack else {
            return
        }
        let dy = StationsSetter.arrOfPoints.first!.y - player.position.y
        self.cam.run(.move(by: CGVector(dx: .zero, dy: dy), duration: 0.6))
      
        player.previousPosition = player.position
        player.moveToNextStation(at: StationsSetter.arrOfPoints.removeFirst())
    }
       
    override func update(_ currentTime: TimeInterval) {
        guard player.status == .movingBack else { return }
        let xPoint = (self.player.position.x + StationsSetter.arrOfPoints.first!.x) / 2
        let yPoint = self.player.position.y + 200
        self.cam.run(.move(to: CGPoint(x: xPoint, y: yPoint), duration: 0.3))
        quake()
    }
    
    func showGameOver() {
        let overNode = OverNode(size: self.frame.size, score: player.score) {
            self.restartCallBack!()
            VibrationManager.shared.vibrate(for: .tap)
        }
        cam.addChild(overNode)
        SoundManager.shared.playSoundEffect(filename: .damage)
        VibrationManager.shared.vibrate(for: .damage)
    }
    
    func quake() {
        let d = CGFloat(8)
        let time = TimeInterval(0.01)
        let sqns = SKAction.sequence([
            .moveBy(x: d, y: d, duration: time),
            .moveBy(x: -d, y: d, duration: time),
            .moveBy(x: d, y: -d, duration: time),
            .moveBy(x: -d, y: -d, duration: time)])
        cam.run(.repeat(sqns, count: 4))
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard player.status == .movingToStation else {
            return
        }
        
        var body = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask == BitMask.player {
            body = contact.bodyB
        } else {
            body = contact.bodyA
        }
        
        if body.categoryBitMask == BitMask.bonus {
            player.shields += 1
            SoundManager.shared.playSoundEffect(filename: .bonus)
        } else {
            VibrationManager.shared.vibrate(for: .damage)
            if player.shields > 0 || UserDefaultsManager.shared.shields > 0 {
                player.moveBack()
            } else {
                guard player.status != .dead else { return }
                player.status = .dead
                player.isPaused = true
                showGameOver()
                UserDefaultsManager.shared.score = player.score
            }
            player.damage()
        }
        
    }
    
}
