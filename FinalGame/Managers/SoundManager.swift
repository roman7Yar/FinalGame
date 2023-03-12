//
//  SoundManager.swift
//  FinalGame
//
//  Created by Roman Yarmoliuk on 26.02.2023.
//

import Foundation
import AVFoundation
import UIKit

class SoundManager {
    
    enum SoundTypes: String {
        case spaceBG, click, damage, bonus, jump, tap
    }
    
    static let shared = SoundManager()
    
    private var backgroundMusicPlayer: AVAudioPlayer?
    private var soundEffectPlayers: [String: AVAudioPlayer] = [:]
    
    private var volume = UserDefaultsManager.shared.soundsVolume
    private var musicVolume = UserDefaultsManager.shared.musicVolume
    
    init() {
        loadSoundEffects()
    }
    
    private func loadSoundEffects() {
        for filename in ["click", "spaceBG", "damage", "bonus", "jump", "tap"] {
            guard let url = Bundle.main.url(forResource: filename, withExtension: "mp3") else { continue }
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                soundEffectPlayers[filename] = player
            } catch {
                print("Could not load sound effect file: \(filename)")
            }
        }
    }
    
    func playBackgroundMusic(filename: SoundTypes) {
        guard UserDefaultsManager.shared.music else { return }
        guard let url = Bundle.main.url(forResource: filename.rawValue, withExtension: "mp3") else { return }
        
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.numberOfLoops = -1 // play indefinitely
            backgroundMusicPlayer?.volume = musicVolume
            backgroundMusicPlayer?.play()
        } catch {
            print("Could not play background music file: \(filename.rawValue)")
        }
    }
    
    func playSoundEffect(filename: SoundTypes) {
        guard UserDefaultsManager.shared.sound else { return }
        
        guard let url = Bundle.main.url(forResource: filename.rawValue, withExtension: "mp3") else { return }
        
        if let player = soundEffectPlayers[filename.rawValue] {
            if !player.isPlaying {
                player.play()
            }
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            soundEffectPlayers[filename.rawValue] = player
            player.volume = volume
            player.play()
        } catch {
            print("Could not play sound effect file: \(filename.rawValue)")
        }
    }
    
    func stopAllSoundEffects() {
        for player in soundEffectPlayers.values {
            player.stop()
        }
        soundEffectPlayers.removeAll()
    }
    
    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
    }
    
    func pauseBackgroundMusic() {
        backgroundMusicPlayer?.pause()
    }
    
    func resumeBackgroundMusic() {
        backgroundMusicPlayer?.play()
    }
    
    func updateVolumeLevel() {
        backgroundMusicPlayer?.volume = UserDefaultsManager.shared.musicVolume
        for player in soundEffectPlayers.values {
            player.volume = UserDefaultsManager.shared.soundsVolume
        }
    }
    
    
}
