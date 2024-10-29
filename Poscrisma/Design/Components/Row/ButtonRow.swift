//
//  ButtonRow.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 26/10/24.
//

import Foundation
import SnapKit
import Epoxy
import UIKit

extension Row {
    final class ButtonRow: UIView, EpoxyableView {
        enum Style: Hashable {
            case primary(horizontalPadding: CGFloat = 0,
                         verticalPadding: CGFloat = 0,
                         backgroundColor: UIColor = .black,
                         tintColor: UIColor = .white,
                         alignment: NSTextAlignment = .center
            )
            case secondary(horizontalPadding: CGFloat = 0,
                           verticalPadding: CGFloat = 0,
                           backgroundColor: UIColor = .black,
                           tintColor: UIColor = .white,
                           alignment: NSTextAlignment = .center
              )
        }
        
        init(style: Style) {
            self.style = style
            super.init(frame: .zero)
            setupButton(style: style)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var button = AppStyle.ScaleButton()
        private var didTap: (() -> Void)?
        private var style: Style
        
        private var text: String?
        
        private func setupButton(style: Style) {
            
            addSubview(button)
            switch style {
            case let .primary(horizontalPadding, verticalPadding, backgroundColor, _, _):
                button.snp.makeConstraints { make in
                    make.height.equalTo(54)
                    make.top.equalTo(snp_topMargin).offset(verticalPadding)
                    make.leading.equalTo(snp_leadingMargin).offset(horizontalPadding)
                    make.bottom.equalTo(snp_bottomMargin).offset(-verticalPadding)
                    make.trailing.equalTo(snp_trailingMargin).offset(-horizontalPadding)
                }
                
                button.backgroundColor = backgroundColor
                button.layer.cornerRadius = 8
                break
            case let .secondary(horizontalPadding, verticalPadding, backgroundColor, _, _):
                button.snp.makeConstraints { make in
                    make.height.equalTo(54)
                    make.top.equalTo(snp_topMargin).offset(verticalPadding)
                    make.leading.equalTo(snp_leadingMargin).offset(horizontalPadding)
                    make.bottom.equalTo(snp_bottomMargin).offset(-verticalPadding)
                    make.trailing.equalTo(snp_trailingMargin).offset(-horizontalPadding)
                }
                
                button.backgroundColor = .clear
                button.layer.borderColor = backgroundColor.cgColor
                button.layer.borderWidth = 1
                button.layer.cornerRadius = 8
                break
            }
            
            button.setAction { [weak self] in
                guard let self else { return }
                handleTap()
            }
        }
        
        struct Content: Equatable {
            var title: String
        }
        
        struct Behaviors {
          var didTap: (() -> Void)?
        }
        
        func setContent(_ content: Content, animated: Bool) {
        
            let label = UILabel()
            label.text = content.title
            switch style {
            case let .primary(_, _, _, tintColor, alignment):
                label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
                label.textColor = tintColor
                label.textAlignment = alignment
                break
            case let .secondary(_, _, _, tintColor, alignment):
                label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
                label.textColor = tintColor
                label.textAlignment = alignment
                break
            }
            button.setCustomContent(label)
        }
        
        func setBehaviors(_ behaviors: Behaviors?) {
            didTap = behaviors?.didTap
        }
        
        @objc private func handleTap() {
            didTap?()
        }
    }
}

