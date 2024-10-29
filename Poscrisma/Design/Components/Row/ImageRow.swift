//
//  ImageRow.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 27/10/24.
//

import SnapKit
import Epoxy
import UIKit

extension Row {
    
    final class Image: UIView, EpoxyableView {
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
}
