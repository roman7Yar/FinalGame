//
//  Levels.swift
//  FinalGame
//
//  Created by Roman Yarmoliuk on 23.02.2023.
//

import Foundation

enum Level: String {
   
    case level1 = "Level 1"
    case level2 = "Level 2"
    case level3 = "Level 3"
    case level4 = "Level 4"
    case level5 = "Level 5"
    case infinity = "Infinity"
    
    var setup: LevelConfig {
        switch self {
        case .level1:
            return LevelConfig(minEnemies: 1,
                               maxEnemies: 3,
                               minDuration: 1.8,
                               maxDuration: 2.5,
                               direction: .clockwise,
                               bigEnemy: false)
        case .level2:
            return LevelConfig(minEnemies: 2,
                               maxEnemies: 4,
                               minDuration: 1.5,
                               maxDuration: 2.0,
                               direction: .counterclockwise,
                               bigEnemy: false)
        case .level3:
            return LevelConfig(minEnemies: 3,
                               maxEnemies: 4,
                               minDuration: 1.3,
                               maxDuration: 1.8,
                               direction: .combine,
                               bigEnemy: false)
        case .level4:
            return LevelConfig(minEnemies: 3,
                               maxEnemies: 4,
                               minDuration: 1.5,
                               maxDuration: 1.8,
                               direction: .combine,
                               bigEnemy: Bool.random())
        case .level5:
            return LevelConfig(minEnemies: 4,
                               maxEnemies: 5,
                               minDuration: 1.3,
                               maxDuration: 1.8,
                               direction: .combine,
                               bigEnemy: Bool.random())
        case .infinity:
            return LevelConfig(minEnemies: 3,
                               maxEnemies: 6,
                               minDuration: 1.4,
                               maxDuration: 1.5,
                               direction: .combine,
                               bigEnemy: Bool.random())
        }
    }
    
}

struct LevelConfig {
    var minEnemies: Int
    var maxEnemies: Int
    var minDuration: TimeInterval
    var maxDuration: TimeInterval
    var direction: Direction
    var bigEnemy: Bool
}

enum Direction {
    case clockwise, counterclockwise, combine
}
