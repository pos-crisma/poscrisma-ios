//
//  Components.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 17/10/24.
//

import Foundation
import SwiftUI

enum Style {
    struct ScaleButtonStyle: ButtonStyle {
        public init() {}
        
        public func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.95 : 1)
                .animation(.linear(duration: 0.2), value: configuration.isPressed)
                .brightness(configuration.isPressed ? -0.05 : 0)
        }
    }
}
