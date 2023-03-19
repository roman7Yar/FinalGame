//
//  Player.swift
//  FinalGame
//
//  Created by Roman Yarmoliuk on 27.02.2023.
//

import SpriteKit

struct PlayerSetup {
    let name: PlayerSkin
    let speed: CGFloat
    var calculatedSpeed: CGFloat { return speed * 800 }
    var shields = 0
    var breakthrouth = 0
    var price = 0
}

enum PlayerSkin: String, CaseIterable {
    case rocket0, rocket1, rocket2, rocket3
    var skinSetup: PlayerSetup {
        switch self {
        case .rocket0:
            return PlayerSetup(name: .rocket0,
                               speed: 1)
        case .rocket1:
            return PlayerSetup(name: .rocket1,
                               speed: 2,
                               price: 300)
        case .rocket2:
            return PlayerSetup(name: .rocket2,
                               speed: 1.5,
                               shields: 5,
                               price: 600)
        case .rocket3:
            return PlayerSetup(name: .rocket3,
                               speed: 1.5,
                               breakthrouth: 3,
                               price: 1200)
        }
    }
   
    var image: UIImage {
        UIImage(named: self.rawValue)!
    }

}

class Player: SKSpriteNode {
    
    var setup = UserDefaultsManager.shared.player.skinSetup
    
    var status = PlayerStatus.arrivedOnStation {
        didSet {
            guard status == .arrivedOnStation else { return }
            isBreakthroughAble = false
            score += 1
            playerLandedCallBack?()
            updateScoreCallBack?(score, false)
        }
    }
    var isBreakthroughAble = false {
        didSet {
            guard oldValue != isBreakthroughAble else { return }
            if isBreakthroughAble {
                guard breakthrough > 0 else { return }
                self.physicsBody?.contactTestBitMask = BitMask.bonus
                playerSpeed = 2000
                updateScoreCallBack?(score, false)
            } else {
                self.physicsBody?.contactTestBitMask = BitMask.bonus | BitMask.enemy
                playerSpeed = setup.calculatedSpeed
            }
        }
    }
    var destination = CGPoint.zero
    var previousPosition = CGPoint.zero
    
    var score = 0 {
        didSet {
            UserDefaultsManager.shared.coins = 1
        }
    }
//    var coins = UserDefaultsManager.shared.coins
    var playerSpeed = CGFloat(800) // per second
   
    var updateScoreCallBack: ((Int, Bool) -> ())?
    var bonusCallBack: (() -> ())?
    var playerLandedCallBack: (() -> ())?
  
    var shields = 0 {
        didSet {
            bonusCallBack?()
            if shields < 0 {
                updateScoreCallBack?(score, true)
            }
        }
    }
   
    var breakthrough = 0 {
        didSet {
            bonusCallBack?()
        }
    }

    
    init() {
        let rocket = setup.name
        let texture = SKTexture(imageNamed: rocket.rawValue)
        let height = CGFloat(36)
        super.init(texture: texture, color: .clear, size: CGSize(width: height, height: height))

        self.playerSpeed = setup.calculatedSpeed
        self.shields = setup.shields
        self.breakthrough = setup.breakthrouth + UserDefaultsManager.shared.breakthrough
        self.name = "player"
        self.zPosition = 1

        self.physicsBody = .init(circleOfRadius: height / 2)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = BitMask.player
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = BitMask.enemy | BitMask.bonus

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rotate() {
        let destinationPoint = StationsSetter.arrOfPoints.first!
        let dx = destinationPoint.x - self.position.x
        let dy = destinationPoint.y - self.position.y
        let angle = atan2(dy, dx) - .pi / 2
        self.run(.rotate(toAngle: angle, duration: 0.2))
    }
    
    func moveToNextStation(at point: CGPoint) {
        self.status = .movingToStation
        if isBreakthroughAble {
            breakthrough -= 1
            UserDefaultsManager.shared.breakthrough = -1
        }
        let duration = calculateTime(player: self.position, destination: point)
        let sqns = SKAction.sequence([.move(to: point, duration: duration),
                                     .run {
                                         self.status = .arrivedOnStation
                                         self.rotate()
                                     }])
        self.run(sqns, withKey: "jump")
        destination = point
        VibrationManager.shared.vibrate(for: .tap)
        SoundManager.shared.playSoundEffect(filename: .jump)
    }
    
    func moveBack() {
        self.status = .movingBack
        self.removeAction(forKey: "jump")
        self.run(.move(to: previousPosition, duration: 0.2)) {
            self.status = .arrivedBack
            self.rotate()
        }
        StationsSetter.arrOfPoints.insert(destination, at: 0)
    }
    
    func damage() {
        let redSqns = SKAction.sequence([.colorize(with: .red, colorBlendFactor: 0.7, duration: 0),
                                         .wait(forDuration: 0.3),
                                         .colorize(withColorBlendFactor: 0, duration: 0)])
       
        self.run(redSqns)
        if shields > 0 {
            shields -= 1
        } else {
            UserDefaultsManager.shared.shields = -1
            bonusCallBack?()
        }
        SoundManager.shared.playSoundEffect(filename: .damage)
    }
   
    func calculateTime(player: CGPoint, destination: CGPoint) -> TimeInterval {
        let x = abs(destination.x - player.x)
        let y = abs(destination.y - player.y)
        let distance = sqrt((x * x) + (y * y))
        
        return distance / playerSpeed
    }
    
    enum PlayerStatus {
        case movingBack, movingToStation, arrivedOnStation, arrivedBack, dead
    }

}
