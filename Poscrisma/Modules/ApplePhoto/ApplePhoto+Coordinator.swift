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
		var detailIndicatorPosition: String?
		/// Gesture Properties
		var offset: CGSize = .zero
		var dragProgress: CGFloat = 0

		func didDetailPageChanged() {
			if let updatedItem = items.first(where: { $0.id == detailScrollPosition }) {
				selectedItem = updatedItem
			}
		}

		func didDetailIndicatorPageChanged() {
			if let updatedItem = items.first(where: { $0.id == detailIndicatorPosition  }) {
				selectedItem = updatedItem
				detailScrollPosition = updatedItem.id
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
				withAnimation(.easeInOut(duration: 0.2), completionCriteria: .removed) {
					animateView = false
					offset = .zero
				} completion: {
					self.resetAnimationProperties()
				}
			}
		}

		func resetAnimationProperties() {
			selectedItem = nil
			detailScrollPosition = nil
			detailIndicatorPosition = nil
			dragProgress = 0
			offset = .zero
		}
	}
}

