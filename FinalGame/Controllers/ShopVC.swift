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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(white: 0, alpha: 0.6)
        let coinLabel = UILabel()
        coinLabel.font = .init(name: "Futura", size: 20)
        coinLabel.textColor = .white
        coinLabel.text = "Coins: \(UserDefaultsManager.shared.coins)"
        
        let shieldLabel = createLabel(withTitle: "Shield: 20 coins")
        let breakthroughLabel = createLabel(withTitle: "Breakthrough: 50 coins")
        
        let backBtn = createButton(withTitle: "Back", action: #selector(backTapped))
        
        let buySieldBtn = SkinButton(title: "Buy")
        let buyBreakthroughBtn = SkinButton(title: "Buy")
        
        buySieldBtn.addTapAction { _ in
            if UserDefaultsManager.shared.coins > 19 {
                UserDefaultsManager.shared.coins = -20
                coinLabel.text = "Coins: \(UserDefaultsManager.shared.coins)"
                self.shields += 1
            }
        }
        
        buyBreakthroughBtn.addTapAction { _ in
            if UserDefaultsManager.shared.coins > 49 {
                UserDefaultsManager.shared.coins = -50
                coinLabel.text = "Coins: \(UserDefaultsManager.shared.coins)"
                self.breakthrough += 1
            }
        }
        
        let skinButtons = PlayerSkin.allCases.map { skin in
            return SkinButton(image: skin)
        }
        
//        let skin1Btn = SkinButton(image: .rocket0)
//        let skin2Btn = SkinButton(image: .rocket1)
//        let skin3Btn = SkinButton(image: .rocket2)
//        let skin4Btn = SkinButton(image: .rocket3)
        
        skinButtons.forEach { button in
            button.addTapAction { btn in self.selectSkin(btn) }
        }
                
        skinButtons.forEach { button in
            stackView.addArrangedSubview(button)
            if UserDefaultsManager.shared.player == button.image?.rawValue {
                selectSkin(button)
            }
        }
        stackView.axis = .horizontal
        stackView.spacing = 8

        view.addSubview(backBtn)
        view.addSubview(coinLabel)
        view.addSubview(shieldLabel)
        view.addSubview(breakthroughLabel)
        view.addSubview(stackView)
        view.addSubview(buySieldBtn)
        view.addSubview(buyBreakthroughBtn)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        coinLabel.translatesAutoresizingMaskIntoConstraints = false
        buySieldBtn.translatesAutoresizingMaskIntoConstraints = false
        buyBreakthroughBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            coinLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            coinLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                        
            stackView.topAnchor.constraint(equalTo: coinLabel.bottomAnchor, constant: 10),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            shieldLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40),
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
        stackView.arrangedSubviews.forEach { view in
            guard let button = view as? SkinButton else { return }
            button.isSelected2 = false
        }
        sender.isSelected2 = true
        UserDefaultsManager.shared.player = sender.image!.rawValue
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

