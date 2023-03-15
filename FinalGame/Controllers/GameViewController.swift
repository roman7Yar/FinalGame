//
//  GameViewController.swift
//  FinalGame
//
//  Created by Roman Yarmoliuk on 21.02.2023.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = SKView(frame: view.frame)
        skView.isMultipleTouchEnabled = true
        view = skView

        setScene()
    }
    
    func setScene() {
        if let view = self.view as! SKView? {
            
            let scene = GameScene(size: self.view.bounds.size)
                                    
            for subview in view.subviews {
                subview.removeFromSuperview()
            }
            
//            let hStackView = UIStackView()
//            hStackView.axis = .horizontal
//            hStackView.spacing = 16
            
            let menuStack = UIStackView()
            menuStack.axis = .vertical
            menuStack.spacing = 16
            
            let bonusVStack = UIStackView()
            bonusVStack.axis = .vertical
            bonusVStack.spacing = 16
            
            let coinsLabel = setupLabel("\(UserDefaultsManager.shared.coins)", size: 12)
            let scoreLabel = setupLabel("Score: 0", size: 24)
            
            let restartImgView = TapImageView(tapImage: .restart)
            
            let settingsImgView = TapImageView(tapImage: .settings)
            let shopImgView = TapImageView(tapImage: .shop)
           
            let shieldImgView = TapImageView(tapImage: .shield)
            shieldImgView.alpha = 0.7

            let breakthroughImgView = TapImageView(tapImage: .breakthrough)
            breakthroughImgView.alpha = 0.7
                                    
            let shieldsLabel = setupShieldsLabel(size: 30)
            let breakthroughLabel = setupShieldsLabel(size: 24)
           
            view.addSubview(scoreLabel)
            view.addSubview(menuStack)
            view.addSubview(bonusVStack)
            view.addSubview(restartImgView)
            
            
//            hStackView.addArrangedSubview(coinsLabel)
//            hStackView.addArrangedSubview(scoreLabel)
            
            menuStack.addArrangedSubview(settingsImgView)
            menuStack.addArrangedSubview(shopImgView)
            
            bonusVStack.addArrangedSubview(shieldImgView)
            bonusVStack.addArrangedSubview(breakthroughImgView)
            
            shopImgView.addSubview(coinsLabel)
            shieldImgView.addSubview(shieldsLabel)
            breakthroughImgView.addSubview(breakthroughLabel)
            
            scene.restartCallBack = {
                self.setScene()
            }

            scene.player.bonusCallBack = {
                if scene.player.shields + UserDefaultsManager.shared.shields > 0 {
                    shieldsLabel.text = "\(scene.player.shields + UserDefaultsManager.shared.shields)"
                    shieldImgView.alpha = 1
                } else {
                    shieldImgView.alpha = 0.7
                    shieldsLabel.text = ""
                }
                if scene.player.breakthrough > 0 {
                    breakthroughLabel.text = "\(scene.player.breakthrough)"
                } else {
                    breakthroughImgView.alpha = 0.7
                    breakthroughLabel.text = ""
                }

            }
                                   
            scene.player.updateScoreCallBack = { score, removeLabel in
                scoreLabel.text = "Score: \(score)"
                coinsLabel.text = "\(UserDefaultsManager.shared.coins)"
                breakthroughImgView.alpha = scene.player.isBreakthroughAble ? 1 : 0.7
                if removeLabel {
                    scoreLabel.removeFromSuperview()
                }
            }
            
            restartImgView.addTapAction {
                self.setScene()
            }
            
            settingsImgView.addTapAction {
                print("Settings Tapped")

                SoundManager.shared.playSoundEffect(filename: .click)
                let vc = SettingsVC()
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
            
            shopImgView.addTapAction {
                print("Shop Tapped")
                SoundManager.shared.playSoundEffect(filename: .click)
                let vc = ShopVC()
                vc.updateBonusesCallback = { shields, breakthrough in
                    UserDefaultsManager.shared.shields = shields
//                    scene.player.shields += shields
                    scene.player.breakthrough += breakthrough
                    
                    UserDefaultsManager.shared.breakthrough = breakthrough
                    coinsLabel.text = "\(UserDefaultsManager.shared.coins)"
                }
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
            
            breakthroughImgView.addTapAction {
                print("Breakthrough Tapped")
                guard scene.player.breakthrough > 0 else { return }
                scene.player.isBreakthroughAble.toggle()
                breakthroughImgView.alpha = scene.player.isBreakthroughAble ? 1 : 0.5
            }
                        
//            hStackView.translatesAutoresizingMaskIntoConstraints = false
            menuStack.translatesAutoresizingMaskIntoConstraints = false
            bonusVStack.translatesAutoresizingMaskIntoConstraints = false
            scoreLabel.translatesAutoresizingMaskIntoConstraints = false
            coinsLabel.translatesAutoresizingMaskIntoConstraints = false
            restartImgView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
                
                menuStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                menuStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
                
                bonusVStack.topAnchor.constraint(equalTo: menuStack.bottomAnchor, constant: 64),
                bonusVStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),

                shieldsLabel.centerYAnchor.constraint(equalTo: shieldImgView.centerYAnchor),
                shieldsLabel.centerXAnchor.constraint(equalTo: shieldImgView.centerXAnchor),
                
                breakthroughLabel.centerYAnchor.constraint(equalTo: breakthroughImgView.centerYAnchor),
                breakthroughLabel.centerXAnchor.constraint(equalTo: breakthroughImgView.centerXAnchor),

                restartImgView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                restartImgView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
                
                coinsLabel.topAnchor.constraint(equalTo: shopImgView.bottomAnchor),
                coinsLabel.centerXAnchor.constraint(equalTo: shopImgView.centerXAnchor)
            ])

            scene.scaleMode = .aspectFill
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            
//            view.showsFPS = true
//            view.showsNodeCount = true
//            view.showsPhysics = true
        }
    }
    
    func setupLabel(_ text: String, size: CGFloat) -> UILabel {
        let label = UILabel()
        label.font = .init(name: "Futura", size: size)
        label.textColor = .white
        label.text = text
       
        return label
    }
    
    func setupShieldsLabel(size: CGFloat) -> UILabel {
        let label = UILabel()

        label.font = .systemFont(ofSize: size)
        label.textColor = .black
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
       
        return label
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
