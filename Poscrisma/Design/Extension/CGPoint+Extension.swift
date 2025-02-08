//
//  CGPoint+Extension.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 08/02/25.
//

import SwiftUI

extension CGPoint {
	func toSize() -> CGSize {
		return .init(width: x, height: y)
	}
}
