//
//  TapImageView.swift
//  FinalGame
//
//  Created by Roman Yarmoliuk on 06.03.2023.
//

import UIKit

class TapImageView: UIImageView {
    private var tapImage: TapImage
    
    private var tapAction: (() -> ())?
    
    init(tapImage: TapImage) {
        self.tapImage = tapImage
        super.init(frame: .zero)
        addTapGesture()
        self.image = tapImage.image
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.tapImage = .settings
        super.init(coder: aDecoder)
        addTapGesture()
        self.image = tapImage.image
    }
        
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        
        tapGesture.delaysTouchesBegan = true
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
    
    func addTapAction(_ action: @escaping () -> ()) {
        tapAction = action
    }
    
    @objc private func handleTapGesture(_ sender: UITapGestureRecognizer) {
        tapAction?()
    }
    
    enum TapImage {
        case settings, breakthrough, shield, shop, restart
        var image: UIImage {
            switch self {
            case .settings:
                return UIImage(named: "settings")!
            case .breakthrough:
                return UIImage(named: "breaktrough")!
            case .shield:
                return UIImage(named: "shield.fill")!
            case .shop:
                return UIImage(named: "shop")!
            case .restart:
                return UIImage(named: "restart")!
            }
        }
    }
}

class SkinButton: UIButton {
    
    var isSelected2 = false {
        didSet {
            if isSelected2 {
                self.layer.borderWidth = 2
                self.layer.borderColor = .init(red: 0.5, green: 1, blue: 0.5, alpha: 1)

            } else {
                self.layer.borderWidth = 1
                self.layer.borderColor = .init(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
    }
    
    private(set) var image: PlayerSkin?
    private var tapAction: ((SkinButton) -> ())?
    
    init(image: PlayerSkin) {
        self.image = image
        super.init(frame: .zero)
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1
        self.layer.borderColor = .init(red: 1, green: 1, blue: 1, alpha: 1)
        setImage(image.image.resized(to: CGSize(width: 80, height: 80)), for: .normal)
    }
    
    init(title: String) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        let buttonTextWidth = self.titleLabel?.intrinsicContentSize.width ?? 0
        self.layer.cornerRadius = 10
        self.backgroundColor = .init(white: 1, alpha: 0.25)
        setTitleColor(.white, for: .normal)
        self.widthAnchor.constraint(greaterThanOrEqualToConstant: buttonTextWidth + 16).isActive = true
    }

    required init?(coder: NSCoder) {
        self.image = .rocket0
        super.init(coder: coder)
    }
    
    func addTapAction(_ action: @escaping (SkinButton) -> ()) {
        tapAction = action
        addTarget(self, action: #selector(handleTapAction(_:)), for: .touchUpInside)
    }
    
    @objc private func handleTapAction(_ sender: SkinButton) {
        tapAction?(sender)
        VibrationManager.shared.vibrate(for: .tap)
        SoundManager.shared.playSoundEffect(filename: .tap)
    }
    
}

