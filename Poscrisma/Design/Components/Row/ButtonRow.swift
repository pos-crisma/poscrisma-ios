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
            case primary(CGFloat = 0, 
                         backgroundColor: UIColor = .black,
                         tintColor: UIColor = .white)
            case secondary(CGFloat = 0, 
                           backgroundColor: UIColor = .black,
                           tintColor: UIColor = .white)
        }
        
        init(style: Style) {
            super.init(frame: .zero)
            setupButton(style: style)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private var button = UIButton()
        private var didTap: (() -> Void)?
        
        private var text: String? {
            get { button.title(for: .normal) }
            set { button.setTitle(newValue, for: .normal) }
        }
        
        private func setupButton(style: Style) {
            
            addSubview(button)
            switch style {
            case let .primary(padding, backgroundColor, tintColor):
                button.snp.makeConstraints { make in
                    make.height.equalTo(50)
                    make.top.equalTo(snp_topMargin).offset(padding)
                    make.leading.equalTo(snp_leadingMargin).offset(padding)
                    make.bottom.equalTo(snp_bottomMargin).offset(-padding)
                    make.trailing.equalTo(snp_trailingMargin).offset(-padding)
                }
                
                button.backgroundColor = backgroundColor
                button.setTitleColor(tintColor, for: .normal)
            case let .secondary(padding, backgroundColor, tintColor):
                button.snp.makeConstraints { make in
                    make.height.equalTo(50)
                    make.top.equalTo(snp_topMargin).offset(padding)
                    make.leading.equalTo(snp_leadingMargin).offset(padding)
                    make.bottom.equalTo(snp_bottomMargin).offset(-padding)
                    make.trailing.equalTo(snp_trailingMargin).offset(-padding)
                }
                
                button.backgroundColor = backgroundColor
                button.setTitleColor(tintColor, for: .normal)
            }
            
            button.layer.cornerRadius = 8
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            
            button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        }
        
        struct Content: Equatable {
            var title: String
        }
        
        struct Behaviors {
          var didTap: (() -> Void)?
        }
        
        func setContent(_ content: Content, animated: Bool) {
            text = content.title
        }
        
        func setBehaviors(_ behaviors: Behaviors?) {
            didTap = behaviors?.didTap
        }
        
        @objc private func handleTap() {
            didTap?()
        }
    }
}
