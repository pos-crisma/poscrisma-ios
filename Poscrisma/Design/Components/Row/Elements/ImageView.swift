//
//  ImageView.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 25/10/24.
//

import Foundation
import UIKit
import Epoxy
import UIKitNavigation

extension Elements {
    
    final class ImageView: UIImageView, EpoxyableView {
        
        // MARK: Lifecycle
        
        init(style: Style) {
            size = style.size
            super.init(image: nil)
            translatesAutoresizingMaskIntoConstraints = false
            tintColor = style.tintColor
            setContentHuggingPriority(.required, for: .vertical)
            setContentHuggingPriority(.required, for: .horizontal)
            setContentCompressionResistancePriority(.required, for: .horizontal)
            setContentCompressionResistancePriority(.required, for: .vertical)
          }

          convenience init(image: UIImage?, size: CGSize) {
            self.init(style: .init(size: size, tintColor: .systemBlue))
            setContent(image, animated: false)
          }

          required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
          }
        
        // MARK: Internal
        
        let size: CGSize
        
        // MARK: StyledView
        
        struct Style: Hashable {
          var size: CGSize
          var tintColor: UIColor = .systemBlue

          func hash(into hasher: inout Hasher) {
            hasher.combine(size.width)
            hasher.combine(size.height)
            hasher.combine(tintColor)
          }
        }
        
        // MARK: ContentConfigurableView
        
        override var intrinsicContentSize: CGSize {
          size
        }

        func setContent(_ content: UIImage?, animated _: Bool) {
          image = content
        }
        
    }
}

extension Elements.ImageView.Style {
    static func style(
        color: UIColor,
        background: UIColor = .clear
    ) -> Self {
        .init(size: .init(width: 22, height: 22), tintColor: .gray)
    }
}
