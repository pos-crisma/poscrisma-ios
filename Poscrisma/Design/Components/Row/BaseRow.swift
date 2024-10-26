//
//  BaseRow.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 24/10/24.
//

import UIKit
import Epoxy

extension Row {
    class BaseRow: UIView {
        init() {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            layoutMargins = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        }
        
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
