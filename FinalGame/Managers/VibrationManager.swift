//
//  VibrationManager.swift
//  FinalGame
//
//  Created by Roman Yarmoliuk on 26.02.2023.
//

import UIKit

class VibrationManager {
    
    static let shared = VibrationManager()
    
    private init() {}
    
    func vibrate(for type: VibrationType) {
        guard UserDefaultsManager.shared.vibration else { return }

        type.apply()
    }
    
    enum VibrationType {
        case tap, damage
        
        func apply() {
            switch self {
            case .tap:
                selectionVibrate()
            case .damage:
                vibrate(for: .error)
            }
        }
        
        private func selectionVibrate() {
            DispatchQueue.main.async {
                let selectionFidbackGenerator = UISelectionFeedbackGenerator()
                selectionFidbackGenerator.prepare()
                selectionFidbackGenerator.selectionChanged()
            }
        }
        
        private func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
            DispatchQueue.main.async {
                let notificationGenerator = UINotificationFeedbackGenerator()
                notificationGenerator.prepare()
                notificationGenerator.notificationOccurred(type)
            }
        }
    }
}
