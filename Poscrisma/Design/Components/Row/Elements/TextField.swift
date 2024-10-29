//
//  TextField.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 24/10/24.
//

import Foundation
import UIKit
import Epoxy
import UIKitNavigation

extension Elements {
    
    final class TextField: UITextField, EpoxyableView {
        
        // MARK: Lifecycle
        
        init(style: Style) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            font = style.font
        }
        
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: Internal
        
        // MARK: StyledView
        
        struct Style: Hashable {
            let font: UIFont
        }
        
        // MARK: ContentConfigurableView
        
        struct Content: Equatable {            
            var text: UIBinding<String>
            var isTextFocused: UIBinding<Bool>
            var placeHolder: String
            var keyboardType = UIKeyboardType.default
            var returnKey = UIReturnKeyType.done
        }
        
        func setContent(_ content: Content, animated _: Bool) {
            bind(text: content.text)
            bind(focus: content.isTextFocused)
            
            placeholder = content.placeHolder
            keyboardType = content.keyboardType
            returnKeyType = content.returnKey
            
        }
        
    }
}

extension Elements.TextField.Style {
    static func style(
        with textStyle: UIFont.TextStyle,
        showBackground: Bool = false)
    -> Elements.TextField.Style
    {
        .init(
            font: UIFont.preferredFont(forTextStyle: textStyle)
        )
    }
}
