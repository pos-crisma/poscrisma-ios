//
//  CGSize+Extension.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 08/02/25.
//

import SwiftUI

extension CGSize {
	static func +(lhs: CGSize, rhs: CGSize) -> CGSize {
		.init(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
	}
}
