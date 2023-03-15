//
//  UserDefaultsManager.swift
//  FinalGame
//
//  Created by Roman Yarmoliuk on 25.02.2023.
//

import Foundation
class UserDefaultsManager {
    enum Keys: String {
        case player, score, coins, shield, breakthrough
        case vibration, sound, music, volume, musikVolume
    }
    
//    private let playerKey = "player"
//    private let vibrationKey = "vibration"
//    private let soundKey = "sound"
//    private let musicKey = "music"
//    private let volumeKey = "volume"
//    private let musikVolumeKey = "musikVolume"
//    private let scoreKey = "score"
//    private let coinsKey = "coins"
//    private let shieldKey = "shield"
//    private let breakthroughKey = "breakthroughKey"
    
    private init() {
        UserDefaults.standard.register(defaults: [
            Keys.player.rawValue : "rocket",
            Keys.vibration.rawValue : true,
            Keys.sound.rawValue : true,
            Keys.music.rawValue : true,
            Keys.volume.rawValue : Float(0.5),
            Keys.musikVolume.rawValue : Float(0.5),
            Keys.score.rawValue : 0,
            Keys.coins.rawValue : 0,
            Keys.shield.rawValue : 0,
            Keys.breakthrough.rawValue : 0
        ])
    }
    
    static let shared = UserDefaultsManager()
    
    var player: String {
        get { UserDefaults.standard.string(forKey: Keys.player.rawValue)! }
        set { UserDefaults.standard.set(newValue, forKey: Keys.player.rawValue) }
    }
    
    var score: Int {
        get { UserDefaults.standard.integer(forKey: Keys.score.rawValue) }
        set {
            if score < newValue {
                UserDefaults.standard.set(newValue, forKey: Keys.score.rawValue)
            }
        }
    }
    
    var coins: Int {
        get { UserDefaults.standard.integer(forKey: Keys.coins.rawValue) }
        set {
            let ammount = coins + newValue
            if ammount > 0 {
                UserDefaults.standard.set(ammount, forKey: Keys.coins.rawValue)
            }
        }
    }

    var vibration: Bool {
        get { return UserDefaults.standard.bool(forKey: Keys.vibration.rawValue) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.vibration.rawValue) }
    }
    
    var sound: Bool {
        get { return UserDefaults.standard.bool(forKey: Keys.sound.rawValue) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.sound.rawValue) }
    }
   
    var music: Bool {
        get { return UserDefaults.standard.bool(forKey: Keys.music.rawValue) }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.music.rawValue)
            if newValue {
                SoundManager.shared.playBackgroundMusic(filename: .spaceBG)
            } else {
                SoundManager.shared.stopBackgroundMusic()
            }
        }
    }

    
    var soundsVolume: Float {
        get { return UserDefaults.standard.float(forKey: Keys.volume.rawValue) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.volume.rawValue) }
    }
    
    var musicVolume: Float {
        get { return UserDefaults.standard.float(forKey: Keys.musikVolume.rawValue) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.musikVolume.rawValue) }
    }

    var shields: Int {
        get { return UserDefaults.standard.integer(forKey: Keys.shield.rawValue) }
        set {
            if shields == 0 && newValue < 0 {
                return
            } else {
                UserDefaults.standard.set(shields + newValue, forKey: Keys.shield.rawValue)
            }
        }
    }
   
    var breakthrough: Int {
        get { return UserDefaults.standard.integer(forKey: Keys.breakthrough.rawValue) }
        set { UserDefaults.standard.set(breakthrough + newValue, forKey: Keys.breakthrough.rawValue) }
    }



}
