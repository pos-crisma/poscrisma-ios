//
//  AppleMusicCoordinator.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 08/02/25.
//

import SwiftUI

extension ApplePhoto {
	@Observable
	class UICoordinator {
		var items: [ApplePhoto.Item] = ApplePhoto.Item.sampleItems
		var selectedItem: ApplePhoto.Item?
		var animateView: Bool = false
		var showDetailView: Bool = false
		var detailScrollPosition: String?

		func toggleView(show: Bool) {
			if show {
				withAnimation(.snappy(duration: 0.2)) {
					animateView = true
					detailScrollPosition = selectedItem?.id
				} completion: {
					self.showDetailView = true
				}
			} else {
				withAnimation(.easeInOut(duration: 0.2)) {
					self.showDetailView = false
				} completion: {
					withAnimation(.snappy(duration: 0.2)) {
						self.animateView = false
					} completion: {
						self.selectedItem = nil
						self.detailScrollPosition = nil
					}
				}
			}
		}
	}
}

