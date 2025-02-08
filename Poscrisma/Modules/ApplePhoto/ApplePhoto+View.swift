//
//  ApplePhotoView.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 08/02/2025.
//

import SwiftUI

extension ApplePhoto {
	struct Screen: View {
		@Environment(UICoordinator.self) private var coordinator

		var body: some View {
			ScrollView(.vertical) {
				LazyVGrid(columns: Array(repeating: GridItem(spacing: 3), count: 3)) {
					ForEach(coordinator.items) { item in
						GridImageView(item)
							.onTapGesture {
								withAnimation(.snappy(duration: 0.35)) {
									coordinator.selectedItem = item
								}
							}
					}
				}
				.padding(.vertical, 16)
			}
			.navigationTitle("Recentes")
		}

		@ViewBuilder
		func GridImageView(_ item: ApplePhoto.Item) -> some View {
			GeometryReader {
				let size = $0.size

				if let previewImage = item.previewImage {
					Image(uiImage: previewImage)
						.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(width: size.width, height: size.height)
						.clipped()
						.opacity(coordinator.selectedItem?.id == item.id ? 0 : 1)
						.anchorPreference(key: HeroKey.self, value: .bounds) { anchor in
							[item.id + "SOURCE": anchor]
						}
				}
			}
			.frame(height: 130)
			.contentShape(.rect)
		}
	}

	struct ContentView: View {
		var coordinator: UICoordinator = .init()
		var body: some View {
			NavigationStack {
				Screen()
					.environment(coordinator)
					.allowsHitTesting(coordinator.selectedItem == nil)
			}
			.overlay {
				if coordinator.selectedItem != nil {
					DetailView()
						.environment(coordinator)
						.allowsHitTesting(coordinator.showDetailView)
				}
			}
 			.overlayPreferenceValue(HeroKey.self) { value in
				if let selectedItem = coordinator.selectedItem,
				   let sAnchor = value[selectedItem.id + "SOURCE"],
				   let dAnchor = value[selectedItem.id + "DEST"] {
					HeroLayer(
						item: selectedItem,
						sAnchor: sAnchor,
						dAnchor: dAnchor
					)
					.environment(coordinator)
				}
			}
		}
	}

	struct DetailView: View {
		@Environment(UICoordinator.self) private var coordinator

		var body: some View {
			GeometryReader {
				let size = $0.size

				ScrollView(.horizontal) {
					LazyHStack(spacing: 0) {
						ForEach(coordinator.items) { item in
							ImageView(item, size: size)
						}
					}
					.scrollTargetLayout()
				}
				.scrollTargetBehavior(.paging)
				.scrollPosition(id: .init(get: {
					coordinator.detailScrollPosition
				}, set: { newPosition in
					coordinator.detailScrollPosition = newPosition
				}))
				.background {
					if let selectedItem = coordinator.selectedItem {
						Rectangle()
							.fill(.clear)
							.anchorPreference(key: HeroKey.self, value: .bounds) { anchor in
								[selectedItem.id + "DEST": anchor]
							}
					}
				}
			}
			.opacity(coordinator.showDetailView ? 1 : 0)
			.onAppear {
				coordinator.toggleView(show: true)
			}
			.overlay(alignment: .topLeading) {
				Button(action: {
					coordinator.toggleView(show: false)
				}, label: {
					Image(systemName: "xmark")
						.font(.title3)
						.fontWeight(.semibold)
						.foregroundStyle(.white)
						.contentShape(.rect)
						.padding()
				})
				.opacity(coordinator.showDetailView ? 1 : 0)
			}
		}

		@ViewBuilder
		func ImageView(_ item: ApplePhoto.Item, size: CGSize) -> some View {
			if let image = item.image {
				Image(uiImage: image)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.clipped()
					.contentShape(.rect)
			}
		}
	}

	struct HeroLayer: View {
		@Environment(UICoordinator.self) private var coordinator

		var item: ApplePhoto.Item
		var sAnchor: Anchor<CGRect>
		var dAnchor: Anchor<CGRect>

		var body: some View {
			GeometryReader { proxy in
				let sRect = proxy[sAnchor]
				let dRect = proxy[dAnchor]
				let animateView = coordinator.animateView

				let viewSize = CGSize(
					width: animateView ? dRect.width : sRect.width,
					height: animateView ? dRect.height : sRect.height
				)

				let viewPosition = CGPoint(
					x: animateView ? dRect.minX : sRect.minX,
					y: animateView ? dRect.minY : sRect.minY
				)

				if let image = item.image {
					Image(uiImage: image)
						.resizable()
						.aspectRatio(contentMode: animateView ? .fit : .fill)
						.frame(width: viewSize.width, height: viewSize.height)
						.clipShape(.rect)
						.position(x: viewPosition.x + viewSize.width / 2, 
								y: viewPosition.y + viewSize.height / 2)
						.animation(.snappy(duration: 0.35), value: animateView)
				}
			}
		}
	}

}

#Preview {
	ApplePhoto.ContentView()
}
