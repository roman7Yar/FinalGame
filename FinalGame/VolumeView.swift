//
//  VolumeView.swift
//  FinalGame
//
//  Created by Roman Yarmoliuk on 27.02.2023.
//

import UIKit

class VolumeView: UIView {
    private let maxBars = 10
    private let barSpacing: CGFloat = 2
    let barHeight: CGFloat = 24
    
    lazy var viewWidth = (barHeight / 2.5 + barSpacing) * CGFloat(maxBars)
    
    var currentBars = 5 {
        didSet {
            setNeedsDisplay()
        }
    }
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.clear(bounds)
        context?.setFillColor(UIColor.white.cgColor)

        let barWidth = barHeight / 2.5
        let totalWidth = CGFloat(maxBars) * barWidth + CGFloat(maxBars - 1) * barSpacing
        let startX = (bounds.width - totalWidth) / 2
        
        for i in 0..<maxBars {
            let x = startX + CGFloat(i) * (barWidth + barSpacing)
            let barRect = CGRect(x: x, y: (bounds.height - barHeight) / 2, width: barWidth, height: barHeight)
            if i < currentBars {
                context?.fill(barRect)
            } else {
                context?.stroke(barRect, width: 1)
            }
        }
    }
    
    func increaseVolume() {
        if currentBars < maxBars {
            currentBars += 1
        }
    }
    
    func decreaseVolume() {
        if currentBars > 0 {
            currentBars -= 1
        }
    }
}
