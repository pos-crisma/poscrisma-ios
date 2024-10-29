//
//  TextRow.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 27/10/24.
//

import Foundation
import Epoxy
import UIKit
import UIKitNavigation
import SnapKit

extension Row {
    final class TextRow: UILabel, EpoxyableView {
        enum Style: Hashable {
            case title(
                fontSize: CGFloat = 22,
                textColor: UIColor = .black,
                weight: UIFont.Weight = .bold,
                alignment: NSTextAlignment = .left
            )
            case subtitle(
                fontSize: CGFloat = 16,
                textColor: UIColor = .black,
                weight: UIFont.Weight = .semibold,
                alignment: NSTextAlignment = .left
            )
            case sectionTitle(
                fontSize: CGFloat = 20,
                textColor: UIColor = .black,
                weight: UIFont.Weight = .semibold,
                alignment: NSTextAlignment = .left
            )
            case body(
                fontSize: CGFloat = 14,
                textColor: UIColor = .black,
                weight: UIFont.Weight = .regular,
                alignment: NSTextAlignment = .left
            )
            case footnote(
                fontSize: CGFloat = 12,
                textColor: UIColor = .black,
                weight: UIFont.Weight = .regular,
                alignment: NSTextAlignment = .left
            )
        }
        
        init(style: Style) {
            super.init(frame: .zero)
            setupLabel(style: style)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupLabel(style: Style) {
            translatesAutoresizingMaskIntoConstraints = false
            numberOfLines = 0
            
            switch style {
            case let .title(ofSize, color, weight, alignment):
                font = UIFont.systemFont(ofSize: ofSize, weight: weight)
                textColor = color
                textAlignment = alignment
            case let .subtitle(ofSize, color, weight, alignment):
                font = UIFont.systemFont(ofSize: ofSize, weight: weight)
                textColor = color
                textAlignment = alignment
            case let .sectionTitle(ofSize, color, weight, alignment):
                font = UIFont.systemFont(ofSize: ofSize, weight: weight)
                textColor = color
                textAlignment = alignment
            case let .body(ofSize, color, weight, alignment):
                font = UIFont.systemFont(ofSize: ofSize, weight: weight)
                textColor = color
                textAlignment = alignment
            case let .footnote(ofSize, color, weight, alignment):
                font = UIFont.systemFont(ofSize: ofSize, weight: weight)
                textColor = color
                textAlignment = alignment
            }
        }
        
        struct Content: Equatable {
            var title: String
        }
        
        func setContent(_ content: Content, animated: Bool) {
            text = content.title
        }
    }
}
