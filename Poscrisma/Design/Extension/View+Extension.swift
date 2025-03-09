//
//  View+Extension.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 09/03/25.
//

import SwiftUI

extension View {

	@ViewBuilder
	func rect(completion: @escaping (CGRect) -> ()) -> some View {
		self
			.overlay {
				GeometryReader {
					let rect = $0.frame(in: .scrollView(axis: .horizontal))

					Color.clear
						.preference(key: RectKey.self, value: rect)
						.onPreferenceChange(RectKey.self, perform: completion)
				}
			}
	}
}
