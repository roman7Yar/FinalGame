//
//  ShopVC.swift
//  FinalGame
//
//  Created by Roman Yarmoliuk on 06.03.2023.
//

import UIKit

class ShopVC: UIViewController {
    
    let stackView = UIStackView()
    
    var updateBonusesCallback: ((Int, Int) -> ())?
    
    var shields = 0
    var breakthrough = 0
    
    var currentSkin = UserDefaultsManager.shared.player
    
    var skinInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let coinLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Futura", size: 20)
        label.textColor = .white
        label.text = "Coins: \(UserDefaultsManager.shared.coins)"
        return label
    }()
    
    
    let skinInfoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let button = SkinButton(title: "Selected")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(white: 0, alpha: 0.8)
        
        let shieldLabel = createLabel(withTitle: "Shield: 20 coins")
        let breakthroughLabel = createLabel(withTitle: "Breakthrough: 50 coins")
        
        let backBtn = createButton(withTitle: "Back", action: #selector(backTapped))
        
        let buySieldBtn = SkinButton(title: "Buy")
        let buyBreakthroughBtn = SkinButton(title: "Buy")
        
        buySieldBtn.addTapAction { _ in
            if self.buy(for: 20) {
                self.shields += 1
            }
        }
        
        buyBreakthroughBtn.addTapAction { _ in
            if self.buy(for: 50) {
                self.breakthrough += 1
            }
        }
        
        let skinButtons = PlayerSkin.allCases.map { skin in
            return SkinButton(image: skin)
        }
        
        skinButtons.forEach { button in
            button.addTapAction { btn in self.selectSkin(btn) }
        }
        
        skinButtons.forEach { button in
            stackView.addArrangedSubview(button)
            if UserDefaultsManager.shared.player.rawValue == button.image?.rawValue {
                selectSkin(button)
            }
        }
        
        button.addTapAction { btn in
            if btn.titleLabel?.text == "Buy" {
                if self.buy(for: self.currentSkin.skinSetup.price) {
                    self.button.setTitle("Select", for: .normal)
                    UserDefaultsManager.shared.skins[self.currentSkin.rawValue] = true
                }
            } else {
                self.button.setTitle("Selected", for: .normal)
                UserDefaultsManager.shared.player = self.currentSkin
            }
        }
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        skinInfoStack.addArrangedSubview(skinInfoLabel)
        
        view.addSubview(backBtn)
        view.addSubview(coinLabel)
        view.addSubview(shieldLabel)
        view.addSubview(breakthroughLabel)
        view.addSubview(stackView)
        view.addSubview(buySieldBtn)
        view.addSubview(buyBreakthroughBtn)
        view.addSubview(skinInfoStack)
        view.addSubview(button)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        coinLabel.translatesAutoresizingMaskIntoConstraints = false
        buySieldBtn.translatesAutoresizingMaskIntoConstraints = false
        buyBreakthroughBtn.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            coinLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            coinLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: coinLabel.bottomAnchor, constant: 10),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            skinInfoStack.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            skinInfoStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skinInfoStack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            
            button.topAnchor.constraint(equalTo: skinInfoLabel.bottomAnchor, constant: 20),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            shieldLabel.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 40),
            shieldLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buySieldBtn.topAnchor.constraint(equalTo: shieldLabel.bottomAnchor, constant: 8),
            buySieldBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buySieldBtn.widthAnchor.constraint(equalToConstant: 50),
            
            breakthroughLabel.topAnchor.constraint(equalTo: buySieldBtn.bottomAnchor, constant: 24),
            breakthroughLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buyBreakthroughBtn.topAnchor.constraint(equalTo: breakthroughLabel.bottomAnchor, constant: 8),
            buyBreakthroughBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buyBreakthroughBtn.widthAnchor.constraint(equalToConstant: 50),
            
            backBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backBtn.topAnchor.constraint(equalTo: buyBreakthroughBtn.bottomAnchor, constant: 40),
            backBtn.widthAnchor.constraint(equalToConstant: 80),
        ])
    }
    
    private func selectSkin(_ sender: SkinButton) {
        let skin = PlayerSkin(rawValue: sender.image!.rawValue)!
        let skinsInfo = UserDefaultsManager.shared.skins
        
        if skin == UserDefaultsManager.shared.player {
            button.setTitle("Selected", for: .normal)
        } else if skinsInfo[skin.rawValue]! {
            button.setTitle("Select", for: .normal)
        } else {
            button.setTitle("Buy", for: .normal)
        }
        stackView.arrangedSubviews.forEach { view in
            guard let button = view as? SkinButton else { return }
            button.isSelected2 = false
        }
        sender.isSelected2 = true
        getSkinInfo(skin.skinSetup)
        currentSkin = skin
    }
    
    private func getSkinInfo(_ setup: PlayerSetup) {
        let speed = "speed: \(setup.speed)  "
        let shields = "shields: \(setup.shields)"
        let breakthrouth = "\nbreakthrouth: \(setup.breakthrouth)  "
        let price = "price: \(setup.price)"
        let result = speed + shields + breakthrouth + price
        skinInfoLabel.text = result
    }
    
    private func createLabel(withTitle text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
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
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    private func buy(for price: Int) -> Bool {
        if price <= UserDefaultsManager.shared.coins {
            UserDefaultsManager.shared.coins = -price
            coinLabel.text = "Coins: \(UserDefaultsManager.shared.coins)"
            return true
        }
        return false
    }
        
    @objc func backTapped() {
        self.dismiss(animated: true)
        updateBonusesCallback?(shields, breakthrough)
    }
    
}


extension UIImage {
    func resized(to newSize: CGSize) -> UIImage {
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? self
    }
}

