//
//  EpoxyTextField.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 24/10/24.
//

import Foundation
import Epoxy
import UIKit
import UIKitNavigation
import SnapKit

extension Row {
    class TextField: BaseRow, EpoxyableView {
        struct Style: Hashable {
            var alignment: HGroup.ItemAlignment = .fill
            var hasIcon = false
            var icon = "list.bullet.clipboard.fill"
            var backgroundColor = UIColor.clear
            var borderColor = UIColor.clear
            var shadowColor = UIColor.clear
            var shadowOffset = CGPoint(x: 0, y: 0)
            var borderWidth = CGFloat.zero
        }
        
        struct Content: Equatable {
            var text: UIBinding<String>
            var isTextFocused: UIBinding<Bool>
            var placeHolder: String
        }
        
        private let style: Style
        private var group: HGroup?
        
        required init(style: Style) {
            self.style = style
            super.init()
            
            setUp()
        }
        
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setUp() {
            group = HGroup(style: .init(alignment: .fill, spacing: 12)) { }
            
            guard let group else { return }
            
            group.install(in: self)
            group.snp.makeConstraints { make in
                make.bottom.trailing.equalToSuperview().offset(-16)
                make.top.leading.equalToSuperview().offset(16)
            }
            
            group.owningView?.layer.borderColor = style.borderColor.cgColor
            group.owningView?.layer.borderWidth = style.borderWidth
            group.owningView?.layer.cornerRadius = 12
            group.owningView?.backgroundColor = .white
        }
        
        // Set of dataIDs to have consistent and unique IDs
        enum DataID {
            case hGroup
            case icon
            case input
        }
        
        func setContent(_ content: Content, animated: Bool) {
            guard let group else { return }
            
            observe { [weak self] in
                guard let self else { return }
                group.setItems {
                    if self.style.hasIcon, let image = UIImage(systemName: self.style.icon) {
                        Elements.ImageView.groupItem(
                            dataID: DataID.icon,
                            content: image,
                            style: .init(size: .init(width: 24, height: 24), tintColor: content.isTextFocused.wrappedValue ? self.style.borderColor : .darkGray)
                        )
                    }
                    
                    Elements.TextField.groupItem(
                        dataID: DataID.input,
                        content: .init(text: content.text, isTextFocused: content.isTextFocused, placeHolder: content.placeHolder),
                        style: .style(with: .body)
                    )
                }
            }

            
            observe { [weak self] in
                guard let self else { return }
                
                withUIKitAnimation(.animate(withDuration: 0.3, delay: 0.3)) {
                    if content.isTextFocused.wrappedValue {
                        group.owningView?.backgroundColor = .white
                        group.owningView?.layer.borderColor = self.style.borderColor.withAlphaComponent(0.3).cgColor
                        group.owningView?.layer.borderWidth = self.style.borderWidth
                        group.owningView?.layer.shadowColor = self.style.shadowColor.cgColor
                        group.owningView?.layer.shadowOpacity = 0.3
                        group.owningView?.layer.shadowOffset = CGSize(
                            width: self.style.shadowOffset.x,
                            height: self.style.shadowOffset.y
                        )
                        group.owningView?.layer.shadowRadius = 22
                    } else {
                        group.owningView?.backgroundColor = .onboardingTitleBackground
                        group.owningView?.layer.borderColor = UIColor.clear.cgColor
                        group.owningView?.layer.borderWidth = 0
                        group.owningView?.layer.shadowOffset = .zero
                        group.owningView?.layer.shadowColor = UIColor.clear.cgColor
                        group.owningView?.layer.shadowOpacity = 0
                        group.owningView?.layer.shadowOffset = .zero
                        group.owningView?.layer.shadowRadius = 0
                    }
                }
                
            }
        }
    }
    
    final class ImageRow: UIView, EpoxyableView {
        private let imageView = UIImageView()
        
        private var heightConstraint: NSLayoutConstraint?
        
        enum Style {
            case large
        }
        
        init(style: Style) {
            super.init(frame: .zero)
            setupImageView(style: style)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupImageView(style: Style) {
            addSubview(imageView)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            imageView.snp.makeConstraints { make in
                make.top.leading.trailing.bottom.equalToSuperview()
            }
        }
        
        struct Content: Equatable {
            var imageName: String
        }
        
        func setContent(_ content: Content, animated: Bool) {
            imageView.image = UIImage(named: content.imageName)
        }
    }
    
    final class TextRow: UILabel, EpoxyableView {
        enum Style: Hashable {
            case title(fontSize: CGFloat = 22, UIColor = .black, weight: UIFont.Weight = .bold)
            case subtitle(fontSize: CGFloat = 16, UIColor = .black, weight: UIFont.Weight = .regular)
            case sectionTitle(fontSize: CGFloat = 20, UIColor = .black, weight: UIFont.Weight = .semibold)
            case body(fontSize: CGFloat = 14, UIColor = .black, weight: UIFont.Weight = .regular)
            case footnote(fontSize: CGFloat = 12, UIColor = .black, weight: UIFont.Weight = .regular)
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
            case let .title(ofSize, color, weight):
                font = UIFont.systemFont(ofSize: ofSize, weight: weight)
                textColor = color
            case let .subtitle(ofSize, color, weight):
                font = UIFont.systemFont(ofSize: ofSize, weight: weight)
                textColor = color
            case let .sectionTitle(ofSize, color, weight):
                font = UIFont.systemFont(ofSize: ofSize, weight: weight)
                textColor = color
            case let .body(ofSize, color, weight):
                font = UIFont.systemFont(ofSize: ofSize, weight: weight)
                textColor = color
            case let .footnote(ofSize, color, weight):
                font = UIFont.systemFont(ofSize: ofSize, weight: weight)
                textColor = color
            }
        }
        
        struct Content: Equatable {
            var title: String
        }
        
        func setContent(_ content: Content, animated: Bool) {
            text = content.title
        }
    }
    
    final class IconTextRow: UIView, EpoxyableView {
        private let iconImageView = UIImageView()
        private let label = UILabel()
        
        init() {
            super.init(frame: .zero)
            setupViews()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupViews() {
            addSubview(iconImageView)
            addSubview(label)
            
            
            iconImageView.tintColor = .systemGray
            label.font = UIFont.systemFont(ofSize: 16)
            
            iconImageView.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize(width: 24, height: 24))
            }

            label.snp.makeConstraints { make in
                make.leading.equalTo(iconImageView.snp.trailing).offset(16)
                make.trailing.equalToSuperview()
                make.centerY.equalToSuperview()
            }

            self.snp.makeConstraints { make in
                make.height.equalTo(44)
            }
            
        }
        
        struct Content: Equatable {
            var icon: String
            var text: String
        }
        
        func setContent(_ content: Content, animated: Bool) {
            iconImageView.image = UIImage(systemName: content.icon)
            label.text = content.text
        }
    }
}


extension Row.TextField.Style {
    static var standard: Row.TextField.Style {
    .init()
  }
}

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}