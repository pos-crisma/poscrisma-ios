//
//  CGVector+Extension.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 17/10/24.
//

import SwiftUI

extension CGVector {
    var magnitude: CGFloat {
        return sqrt(dx*dx + dy*dy)
    }
}
