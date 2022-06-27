//
//  HapticsManager.swift
//  SwiftfulCrypto
//
//  Created by KANISHK VIJAYWARGIYA on 27/03/22.
//

import Foundation
import SwiftUI

class HapticManager { // haptic singleton class
    static let instance = HapticManager()
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
