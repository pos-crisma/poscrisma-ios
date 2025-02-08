//
//  AppleMusic+View.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 08/02/25.
//

import SwiftUI
import AVKit

extension AppleMusic {
	struct Screen: View {
		@State private var selectedIndex: Int = 0
		@State private var showMiniPlayer = false

		var body: some View {
			TabView(selection: $selectedIndex) {
				NavigationStack() {
					Text("Home View")
						.navigationTitle("Home")
				}
				.tabItem {
					Text("Home view")
					Image(systemName: "house.fill")
						.renderingMode(.template)
				}
				.tag(0)

				NavigationStack() {
					Text("Profile view")
						.navigationTitle("Profile")
				}
				.tabItem {
					Label("Profile", systemImage: "person.fill")
				}
				.tag(1)


				NavigationStack() {
					Text("Profile view")
						.navigationTitle("Profile")
				}
				.tabItem {
					Label("Profile", systemImage: "person.fill")
				}
				.tag(2)

				NavigationStack() {
					Text("About view")
						.navigationTitle("About")

				}
				.tabItem {
					Text("About view")
					Image(systemName: "info.circle")
				}
				.badge("12")
				.tag(3)
			}
			.universalOverlay(show: $showMiniPlayer) {
				ExpandablePlayer(show: $showMiniPlayer)
			}
			.onAppear {
				showMiniPlayer = true
			}
		}
	}

	// MARK: - BaseScreen
	struct BaseScreen: View {
		@State private var show: Bool = false
		@State private var showSheet: Bool = false
		@State private var text: String = ""

		var body: some View {
			NavigationStack {
				List {
					TextField("Message", text: $text)
					Button("Floating Video Player") {
						show.toggle()
					}
					.universalOverlay(show: $show) {
						FloatingVideoPlayerView(show: $show)
					}
					Button("Show Dummy Sheet") {
						showSheet.toggle()
					}
				}
				.navigationTitle("Universal Overlay")
			}
			.sheet(isPresented: $showSheet, content: {
				Text("Hello From Sheet!")
			})
		}
	}

	// MARK: - FloatingVideoPlayerView
	struct FloatingVideoPlayerView: View {
		@Binding var show: Bool

		// View Properties
		@State private var player: AVPlayer?
		@State private var offset: CGSize = .zero
		@State private var lastStoredOffset: CGSize = .zero

		var body: some View {
			GeometryReader {
				let size = $0.size

				Group {
					if let videoURL {
						VideoPlayer(player: player)
							.background(.gray)
							.clipShape(.rect(cornerRadius: 8))
					} else {
						RoundedRectangle(cornerRadius: 8)
							.fill(.gray)
					}
				}
				.frame(height: 250)
				.offset(offset)
				.gesture(
					DragGesture()
						.onChanged { value in
							let transition = value.translation + lastStoredOffset
							offset = transition
						}
						.onEnded { value in
							withAnimation(.bouncy) {
								offset.width = 0

								if offset.height < 0 {
									offset.height = 0
								}

								if offset.height > (size.height - 250) {
									offset.height = (size.height - 250)
								}

								lastStoredOffset = offset
							}
						}
				)
				.frame(maxHeight: .infinity, alignment: .top)
			}
			.transition(.blurReplace)
			.onAppear {
				if let videoURL {
					player = AVPlayer(url: videoURL)
					player?.play()
				}
			}
		}

		var videoURL: URL? {
			if let bundle = Bundle.main.path(forResource: "Area", ofType: "mp4") {
				return .init(filePath: bundle)
			}

			return nil
		}
	}


	// MARK: - ExpandablePlayer
	struct ExpandablePlayer: View {
		@Binding var show: Bool
		@State private var expandPlayer: Bool = false
		@State private var offsetY: CGFloat = 0

		@State private var mainWindow: UIWindow?
		@State private var windowProgress: CGFloat = 0

		@Namespace private var animation

		var body: some View {
			GeometryReader {
				let size = $0.size
				let safeArea = $0.safeAreaInsets

				ZStack(alignment: .top) {
					ZStack {
						Rectangle()
							.fill(.playerBackground)

						Rectangle()
							.fill(.linearGradient(colors: [.artwork1, .artwork2, .artwork3], startPoint: .top, endPoint: .bottom))
							.opacity(expandPlayer ? 1 : 0)

					}
					.clipShape(.rect(cornerRadius: 16))
					.frame(height: expandPlayer ? nil : 55)
					.shadow(color: .primary.opacity(0.06), radius: 5, x: 5, y: 5)
					.shadow(color: .primary.opacity(0.05), radius: 5, x: -5, y: -5)

					MiniPlayer()
						.opacity(expandPlayer ? 0 : 1)

					ExpandedPlayer(size, safeArea)
						.opacity(expandPlayer ? 1 : 0)
				}
				.frame(height: expandPlayer ? nil : 55, alignment: .top)
				.frame(maxHeight: .infinity, alignment: .bottom)
				.padding(.bottom, expandPlayer ? 0 : safeArea.bottom + 55)
				.padding(.horizontal, expandPlayer ? 0 : 16)
				.offset(y: offsetY)
				.gesture(
					PanGesture { value in
						let translation = max(value.translation.height, 0)
						offsetY = translation
						windowProgress = max(min(translation / size.height, 1), 0) * 0.1

						resizeWindow(0.1 - windowProgress)
					} onEnd: { value in
						let translation = max(value.translation.height, 0)
						let velocity = value.velocity.height / 5

						withAnimation(.smooth(duration: 0.3, extraBounce: 0)) {
							if (translation + velocity) > (size.height * 0.5) {
								expandPlayer = false

								resetWindowWithAnimation()
							} else {
								UIView.animate(withDuration: 0.3) {
									resizeWindow(0.1)
								}
							}

							offsetY = 0
						}
					}
				)
				.ignoresSafeArea()
			}
			.onAppear {
				if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow, mainWindow == nil {
					mainWindow = window
				}
			}
		}

		@ViewBuilder
		func MiniPlayer() -> some View {
			HStack(spacing: 12) {

				ZStack {
					if !expandPlayer {
						Image(.cabin)
							.resizable()
							.aspectRatio(contentMode: .fit)
							.clipShape(.rect(cornerRadius: 10))
							.matchedGeometryEffect(id: "Artwork", in: animation)
					}
				}
				.frame(width: 45, height: 45)

				Text("Calm Down")

				Spacer(minLength: 0)

				Group {
					Button("", systemImage: "play.fill") { }
					Button("", systemImage: "forward.fill") { }
				}
				.font(.title3)
				.foregroundStyle(.primary)
			}
			.padding(.horizontal, 10)
			.frame(height: 55)
			.contentShape(.rect)
			.onTapGesture {
				withAnimation(.smooth(duration: 0.3, extraBounce: 0)) {
					expandPlayer = true
				}

				UIView.animate(withDuration: 0.3) {
					resizeWindow(0.1)
				}
			}
		}

		@ViewBuilder
		func ExpandedPlayer(_ size: CGSize, _ safeArea: EdgeInsets) -> some View {
			VStack(spacing: 12) {
				Capsule()
					.fill()
					.frame(width: 35, height: 5)
					.offset(y: -10)

				HStack(spacing: 12) {
					ZStack {
						if expandPlayer {
							Image(.cabin)
								.resizable()
								.aspectRatio(contentMode: .fit)
								.clipShape(.rect(cornerRadius: 10))
								.matchedGeometryEffect(id: "Artwork", in: animation)
								.transition(.offset(y: 1))
						}
					}
					.frame(width: 80, height: 80)

					VStack(alignment: .leading, spacing: 2) {
						Text("Calm Down")
							.fontWeight(.semibold)
							.foregroundStyle(.white)
						Text("Rema, Selena Gomez")
							.font(.caption2)
							.foregroundStyle(.white.secondary)
					}

					Spacer(minLength: 0)

					Group {
						Button("", systemImage: "star.circle.fill") { }
						Button("", systemImage: "ellipsis.circle.fill") { }
					}
					.font(.title3)
					.foregroundStyle(.primary)
				}
			}
			.padding(16)
			.padding(.top, safeArea.top)
		}

		func resizeWindow(_ progress: CGFloat) {
			if let mainWindow = mainWindow?.subviews.first {
				let offsetY = (mainWindow.frame.height * progress) / 2

				mainWindow.layer.cornerRadius = (progress / 0.1) * 30
				mainWindow.layer.masksToBounds = true

				mainWindow.transform = .identity.scaledBy(x: 1 - progress, y: 1 - progress).translatedBy(x: 0, y: offsetY)
			}
		}

		func resetWindowWithAnimation() {
			if let mainWindow = mainWindow?.subviews.first {
				UIView.animate(withDuration: 0.3) {
					mainWindow.layer.cornerRadius = 0
					mainWindow.transform = .identity
				}
			}
		}
	}
}

extension CGSize {
	static func +(lhs: CGSize, rhs: CGSize) -> CGSize {
		.init(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
	}
}
