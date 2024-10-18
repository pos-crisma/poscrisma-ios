//
//  Haptics.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 17/10/24.
//

import CoreHaptics
import UIKit

extension Manager {
    enum HapticEvent {
        case impact(UIImpactFeedbackGenerator.FeedbackStyle)
        case notification(UINotificationFeedbackGenerator.FeedbackType)
        case selection
        case custom(intensity: Float, sharpness: Float)
        case continuous(intensity: Float, sharpness: Float, duration: TimeInterval)
    }

    class Haptic {
        static let shared = Haptic()
        
        private var engine: CHHapticEngine?
        
        private init() {
            prepareHaptics()
        }
        
        private func prepareHaptics() {
            guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
            
            do {
                engine = try CHHapticEngine()
                try engine?.start()
            } catch {
                print("There was an error creating the engine: \(error.localizedDescription)")
            }
        }
        
        func playHaptic(for event: HapticEvent) {
            switch event {
            case .impact(let style):
                impactFeedback(style: style)
            case .notification(let type):
                notificationFeedback(type: type)
            case .selection:
                selectionFeedback()
            case .custom(let intensity, let sharpness):
                customHaptic(intensity: intensity, sharpness: sharpness)
            case .continuous(let intensity, let sharpness, let duration):
                continuousHaptic(intensity: intensity, sharpness: sharpness, duration: duration)
            }
        }
        
        private func impactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
            let impact = UIImpactFeedbackGenerator(style: style)
            impact.impactOccurred()
        }
        
        private func notificationFeedback(type: UINotificationFeedbackGenerator.FeedbackType) {
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(type)
        }
        
        private func selectionFeedback() {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
        
        private func customHaptic(intensity: Float, sharpness: Float) {
            guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
            
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
            ], relativeTime: 0)
            
            do {
                let pattern = try CHHapticPattern(events: [event], parameters: [])
                let player = try engine?.makePlayer(with: pattern)
                try player?.start(atTime: 0)
            } catch {
                print("Failed to play custom haptic: \(error.localizedDescription)")
            }
        }
        
        private func continuousHaptic(intensity: Float, sharpness: Float, duration: TimeInterval) {
            guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
            
            let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
            ], relativeTime: 0, duration: duration)
            
            do {
                let pattern = try CHHapticPattern(events: [event], parameters: [])
                let player = try engine?.makePlayer(with: pattern)
                try player?.start(atTime: 0)
            } catch {
                print("Failed to play continuous haptic: \(error.localizedDescription)")
            }
        }
    }

}
