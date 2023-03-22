//
//  SettingsVC.swift
//  FinalGame
//
//  Created by Roman Yarmoliuk on 25.02.2023.
//

import UIKit

class SettingsVC: UIViewController {
        
    var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.frame.size = CGSize(width: 100, height: 20)
        titleLabel.text = "Settings"
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 30)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
        
    let soundVolumeView = VolumeView()
    let musicVolumeView = VolumeView()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 12
        return stackView
    }()
    
    var hSoundVolumeSV: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    var hMusikVolumeSV: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()

        let fontSize = CGFloat(32)

        soundVolumeView.currentBars = Int(UserDefaultsManager.shared.soundsVolume * 10)
        musicVolumeView.currentBars = Int(UserDefaultsManager.shared.musicVolume * 10)
        
        view.backgroundColor = UIColor(cgColor: CGColor(red: 0, green: 0, blue: 0, alpha: 0.8))
        
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        
        let minusSoundBttn = createButton(withTitle: "-", action: #selector(minusSoundTapped))
        let plusSoundBttn = createButton(withTitle: "+", action: #selector(plusSoundTapped))
        
        minusSoundBttn.backgroundColor = .clear
        minusSoundBttn.titleLabel?.font = .boldSystemFont(ofSize: fontSize)

        plusSoundBttn.backgroundColor = .clear
        plusSoundBttn.titleLabel?.font = .boldSystemFont(ofSize: fontSize)

        hSoundVolumeSV.addArrangedSubview(minusSoundBttn)
        hSoundVolumeSV.addArrangedSubview(soundVolumeView)
        hSoundVolumeSV.addArrangedSubview(plusSoundBttn)
        
        let minusMusicBttn = createButton(withTitle: "-", action: #selector(minusMusicTapped))
        let plusMusicBttn = createButton(withTitle: "+", action: #selector(plusMusicTapped))
        
        minusMusicBttn.backgroundColor = .clear
        minusMusicBttn.titleLabel?.font = .boldSystemFont(ofSize: fontSize)

        plusMusicBttn.backgroundColor = .clear
        plusMusicBttn.titleLabel?.font = .boldSystemFont(ofSize: fontSize)
        
        hMusikVolumeSV.addArrangedSubview(minusMusicBttn)
        hMusikVolumeSV.addArrangedSubview(musicVolumeView)
        hMusikVolumeSV.addArrangedSubview(plusMusicBttn)
        
        let soundLabel = createLabel("Sound")
        let musikLabel = createLabel("Music")
        let vibrationLabel = createLabel("Vibration")
      
        let vibrationTitle = UserDefaultsManager.shared.vibration ? "On" : "Off"
        let soundTitle = UserDefaultsManager.shared.sound ? "On" : "Off"
        let musikTitle = UserDefaultsManager.shared.music ? "On" : "Off"

        let soundBtn = createButton(withTitle: soundTitle, action: #selector(soundTapped(_:)))
        let musikBtn = createButton(withTitle: musikTitle, action: #selector(musikTapped(_:)))
        let vibrationBtn = createButton(withTitle: vibrationTitle, action: #selector(vibrationTapped(_:)))
        let closeBtn = createButton(withTitle: "Close", action: #selector(closeTapped))
        
        stackView.addArrangedSubview(soundLabel)
        stackView.addArrangedSubview(hSoundVolumeSV)
        addButtonToStack(soundBtn)
        stackView.setCustomSpacing(24, after: soundBtn)
     
        stackView.addArrangedSubview(musikLabel)
        stackView.addArrangedSubview(hMusikVolumeSV)
        addButtonToStack(musikBtn)
        stackView.setCustomSpacing(24, after: musikBtn)

        stackView.addArrangedSubview(vibrationLabel)
        addButtonToStack(vibrationBtn)
        stackView.setCustomSpacing(48, after: vibrationBtn)

        addButtonToStack(closeBtn)
        
        soundVolumeView.translatesAutoresizingMaskIntoConstraints = false
        musicVolumeView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
           
            soundLabel.heightAnchor.constraint(equalToConstant: 25),
            musikLabel.heightAnchor.constraint(equalToConstant: 25),
            vibrationLabel.heightAnchor.constraint(equalToConstant: 25),

            soundVolumeView.widthAnchor.constraint(equalToConstant: soundVolumeView.viewWidth),
            soundVolumeView.heightAnchor.constraint(equalToConstant: soundVolumeView.barHeight),
            
            musicVolumeView.widthAnchor.constraint(equalToConstant: musicVolumeView.viewWidth),
            musicVolumeView.heightAnchor.constraint(equalToConstant: musicVolumeView.barHeight),
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
       
        hSoundVolumeSV.isHidden = !UserDefaultsManager.shared.sound
        hMusikVolumeSV.isHidden = !UserDefaultsManager.shared.music

    }
    
    func createLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createButton(withTitle title: String, action: Selector) -> UIButton {
        
        let button = UIButton()
        button.backgroundColor = .init(white: 1, alpha: 0.25)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 22)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
       
        return button
    }
    
    private func addButtonToStack(_ button: UIButton) {
        
        stackView.addArrangedSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    @objc func vibrationTapped(_ sender: UIButton) {
        UserDefaultsManager.shared.vibration.toggle()
        VibrationManager.shared.vibrate(for: .tap)
        SoundManager.shared.playSoundEffect(filename: .tap)
        let vibrationTitle = UserDefaultsManager.shared.vibration ? "On" : "Off"
        sender.setTitle(vibrationTitle, for: .normal)
    }
    
    @objc func soundTapped(_ sender: UIButton) {
        UserDefaultsManager.shared.sound.toggle()
        hSoundVolumeSV.isHidden = !UserDefaultsManager.shared.sound
        VibrationManager.shared.vibrate(for: .tap)
        SoundManager.shared.playSoundEffect(filename: .tap)
        let soundTitle = UserDefaultsManager.shared.sound ? "On" : "Off"
        sender.setTitle(soundTitle, for: .normal)
        print(UserDefaultsManager.shared.sound)
    }
    
    @objc func musikTapped(_ sender: UIButton) {
        UserDefaultsManager.shared.music.toggle()
        hMusikVolumeSV.isHidden = !UserDefaultsManager.shared.music
        VibrationManager.shared.vibrate(for: .tap)
        SoundManager.shared.playSoundEffect(filename: .tap)
        let soundTitle = UserDefaultsManager.shared.music ? "On" : "Off"
        sender.setTitle(soundTitle, for: .normal)
        print(UserDefaultsManager.shared.music)

    }

    @objc func closeTapped() {
        self.dismiss(animated: true)
        VibrationManager.shared.vibrate(for: .tap)
        SoundManager.shared.playSoundEffect(filename: .click)
    }
    
    @objc func minusSoundTapped() {
        soundVolumeView.decreaseVolume()
        UserDefaultsManager.shared.soundsVolume = Float(soundVolumeView.currentBars) / 10
        VibrationManager.shared.vibrate(for: .tap)
        SoundManager.shared.playSoundEffect(filename: .tap)
        SoundManager.shared.updateVolumeLevel()
    }
    
    @objc func plusSoundTapped() {
        soundVolumeView.increaseVolume()
        UserDefaultsManager.shared.soundsVolume = Float(soundVolumeView.currentBars) / 10
        VibrationManager.shared.vibrate(for: .tap)
        SoundManager.shared.playSoundEffect(filename: .tap)
        SoundManager.shared.updateVolumeLevel()
    }

    @objc func minusMusicTapped() {
        musicVolumeView.decreaseVolume()
        UserDefaultsManager.shared.musicVolume = Float(musicVolumeView.currentBars) / 10
        VibrationManager.shared.vibrate(for: .tap)
        SoundManager.shared.updateVolumeLevel()
    }
    
    @objc func plusMusicTapped() {
        musicVolumeView.increaseVolume()
        UserDefaultsManager.shared.musicVolume = Float(musicVolumeView.currentBars) / 10
        VibrationManager.shared.vibrate(for: .tap)
        SoundManager.shared.updateVolumeLevel()
    }

    deinit {
        print("Settings deinited")
    }
    
}

