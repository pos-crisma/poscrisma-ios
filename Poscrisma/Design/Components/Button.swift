//
//  Components.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 17/10/24.
//

import Foundation
import SwiftUI
import UIKit

enum AppStyle {
    struct ScaleButtonStyle: ButtonStyle {
        public init() {}
        
        public func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.95 : 1)
                .animation(.linear(duration: 0.2), value: configuration.isPressed)
                .brightness(configuration.isPressed ? -0.05 : 0)
        }
    }
    

    class ScaleButton: UIButton {
        
        private var originalScale: CGFloat = 1.0
        private var pressedScale: CGFloat = 0.95
        private var animationDuration: TimeInterval = 0.2
        
        private var customContentView: UIView?
        private var action: (() -> Void)?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupButton()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupButton()
        }
        
        private func setupButton() {
            addTarget(self, action: #selector(touchDown), for: .touchDown)
            addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
            addTarget(self, action: #selector(executeAction), for: .touchUpInside)
        }
        
        func setCustomContent(_ view: UIView) {
            customContentView?.removeFromSuperview()
            customContentView = view
            addSubview(view)
            setNeedsLayout()
        }
        
        func setAction(_ action: @escaping () -> Void) {
            self.action = action
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            customContentView?.frame = bounds
        }
        
        @objc private func touchDown() {
            UIView.animate(withDuration: animationDuration) {
                self.transform = CGAffineTransform(scaleX: self.pressedScale, y: self.pressedScale)
                self.alpha = 0.95  // Simula o efeito de brilho
            }
        }
        
        @objc private func touchUp() {
            UIView.animate(withDuration: animationDuration) {
                self.transform = CGAffineTransform(scaleX: self.originalScale, y: self.originalScale)
                self.alpha = 1.0
            }
        }
        
        @objc private func executeAction() {
            Manager.Haptic.shared.playHaptic(for: .impact(.medium))
            action?()
        }
    }
}
