//
//  RectKey.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 09/03/25.
//

import SwiftUI

struct RectKey: PreferenceKey {
	static var defaultValue: CGRect = .zero
	static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
		value = nextValue()
	}
}

