//
//  UserDefaultsManager.swift
//  FinalGame
//
//  Created by Roman Yarmoliuk on 25.02.2023.
//

import Foundation
class UserDefaultsManager {
    
    private let playerKey = "player"
    private let vibrationKey = "vibration"
    private let soundKey = "sound"
    private let musicKey = "music"
    private let scoreKey = "score"
    private let coinsKey = "coins"
    private let volumeKey = "volume"
    private let musikVolumeKey = "musikVolume"
    
    private init() {
        UserDefaults.standard.register(defaults: [
            playerKey : "rocket",
            vibrationKey : true,
            soundKey : true,
            musicKey : true,
            scoreKey : 0,
            coinsKey : 0,
            volumeKey : Float(0.5),
            musikVolumeKey : Float(0.5)
        ])
    }
    
    static let shared = UserDefaultsManager()
    
    var player: String {
        get { UserDefaults.standard.string(forKey: playerKey)! }
        set { UserDefaults.standard.set(newValue, forKey: playerKey) }
    }
    
    var score: Int {
        get { UserDefaults.standard.integer(forKey: scoreKey) }
        set {
            if score < newValue {
                UserDefaults.standard.set(newValue, forKey: scoreKey)
            }
        }
    }
    
    var coins: Int {
        get { UserDefaults.standard.integer(forKey: coinsKey) }
        set {
            let ammount = coins + newValue
            if ammount > 0 {
                UserDefaults.standard.set(ammount, forKey: coinsKey)
            }
        }
    }

    var vibration: Bool {
        get { return UserDefaults.standard.bool(forKey: vibrationKey) }
        set { UserDefaults.standard.set(newValue, forKey: vibrationKey) }
    }
    
    var sound: Bool {
        get { return UserDefaults.standard.bool(forKey: soundKey) }
        set { UserDefaults.standard.set(newValue, forKey: soundKey) }
    }
   
    var music: Bool {
        get { return UserDefaults.standard.bool(forKey: musicKey) }
        set {
            UserDefaults.standard.set(newValue, forKey: musicKey)
            if newValue {
                SoundManager.shared.playBackgroundMusic(filename: .spaceBG)
            } else {
                SoundManager.shared.stopBackgroundMusic()
            }
        }
    }

    
    var soundsVolume: Float {
        get { return UserDefaults.standard.float(forKey: volumeKey) }
        set { UserDefaults.standard.set(newValue, forKey: volumeKey) }
    }
    
    var musicVolume: Float {
        get { return UserDefaults.standard.float(forKey: musikVolumeKey) }
        set { UserDefaults.standard.set(newValue, forKey: musikVolumeKey) }
    }

    


}
