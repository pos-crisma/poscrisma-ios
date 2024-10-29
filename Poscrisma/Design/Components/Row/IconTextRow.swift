//
//  IconTextRow.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 27/10/24.
//

import SnapKit
import Epoxy
import UIKit

extension Row {
    final class IconText: UIView, EpoxyableView {
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
