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

		/// Animation Properties
		var selectedItem: ApplePhoto.Item?
		var animateView: Bool = false
		var showDetailView: Bool = false
		/// Scroll Positions
		var detailScrollPosition: String?

		func didDetailPageChanged() {
			if let updatedItem = items.first(where: { $0.id == detailScrollPosition }) {
				selectedItem = updatedItem
			}
		}

		func toggleView(show: Bool) {
			if show {
				detailScrollPosition = selectedItem?.id
				withAnimation(.easeInOut(duration: 0.2), completionCriteria: .removed) {
					animateView = true
				} completion: {
					self.showDetailView = true
				}
			} else {
				self.showDetailView = false
				withAnimation(.easeInOut(duration: 0.2)) {
					self.animateView = false
				} completion: {
					self.resetAnimationProperties()
				}
			}
		}

		func resetAnimationProperties() {
			selectedItem = nil
			detailScrollPosition = nil 
		}
	}
}

