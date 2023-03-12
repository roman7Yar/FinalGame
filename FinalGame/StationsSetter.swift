//
//  StationsSetter.swift
//  FinalGame
//
//  Created by Roman Yarmoliuk on 27.02.2023.
//

import SpriteKit

class StationsSetter {
    var station = SKShapeNode()
    
    static var arrOfPoints = [CGPoint.zero]
    
    private var stationsCount = 0
    
    func createFirstStation() -> SKShapeNode {
        station = .init(circleOfRadius: 60)
        station.position = .zero
        return station
    }
    
    func createStation(on node: SKNode, currentLevel: Level) {
        
        let newPoint = CGPoint(x: StationsSetter.arrOfPoints.last!.x + .random(in: -240...240),
                               y: StationsSetter.arrOfPoints.last!.y + .random(in: 200...400))
        
        StationsSetter.arrOfPoints.append(newPoint)

        var copy = station.copy() as! SKShapeNode
        
        copy = .init(circleOfRadius: 32)
        copy.position = newPoint
        copy.name = "station"
                
        node.addChild(copy)
        
        stationsCount += 1
        if stationsCount % 7 == 0 {
            Bonus.addShield(to: copy)
        }
        
        Enemy.addEnemies(to: copy, level: currentLevel)
    }
}

