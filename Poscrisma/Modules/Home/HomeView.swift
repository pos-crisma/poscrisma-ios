//
//  HomeView.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 11/09/2024.
//

import SwiftUI
import UIKit
import CustomDump
import UIKitNavigation

extension Home {
	struct ViewController: View {
		@State var controller: Controller


		init(controller: Controller) {
			UIScrollView.appearance().bounces = false // <-- Disable bounce

			self.controller = controller
		}

		var body: some View {
			Screen(controller: controller)
				.fullScreenCover(item: $controller.destination.airbnb) { model in
					UIViewControllerRepresenting {
						Airbnb.ViewController(controller: model)
					}
					.ignoresSafeArea()
				}
				.sheet(item: $controller.destination.isError) { model in
					UIViewControllerRepresenting {
						OnError.ViewController(model: model)
					}
					.ignoresSafeArea()
				}
		}
	}

	struct Screen: View {
		@State var controller: Controller
		@Namespace var animation

		var body: some View {
			GeometryReader {
				let size = $0.size
				let safeAreaInsets = $0.safeAreaInsets

				ZStack(alignment: .top) {
					if controller.showReplay {
						Color.homeBackgroundReplay
							.ignoresSafeArea()
							.matchedGeometryEffect(id: "home.background", in: animation)
					} else {
						Color.white
							.ignoresSafeArea()
							.matchedGeometryEffect(id: "home.background", in: animation)
					}

					VStack(spacing: 0) {
						if controller.showReplay {
							HeaderReplay()
								.transition(.opacity)
						}

						RoundedRectangle(cornerRadius: controller.showReplay ? 12 : 0)
							.fill(.white)
							.overlay(alignment: .top) {
								HomeView(isExpanded: !controller.showReplay)
									.padding(.top, !controller.showReplay ? safeAreaInsets.top : 0)
							}
							.ignoresSafeArea(.container, edges: controller.showReplay ? .bottom : .all)
							.matchedGeometryEffect(id: "home.content", in: animation)
							.padding(.top, controller.showReplay ? 10 : 0)
							.frame(height: controller.showReplay ? nil : size.height)
					}
					.animation(.spring(response: 0.5, dampingFraction: 0.8), value: controller.showReplay)
				}
			}
		}

		@ViewBuilder
		private func HeaderReplay() -> some View {
			Button {
				Manager.Haptic.shared.playHaptic(for: .impact(.rigid))
				controller.handleReplay()
			} label: {
				HStack(alignment: .center, spacing: 8) {
					Image(systemName: "arrow.counterclockwise")
					Text("Replay dos acamps")
				}
			}
			.padding()
			.foregroundStyle(.black)
			.buttonStyle(.scale)
		}

		@ViewBuilder
		private func HomeView(isExpanded: Bool) -> some View {
			VStack(spacing: 0) {
				// Barra de pesquisa
				HStack {
					Button {
						Manager.Haptic.shared.playHaptic(for: .impact(.rigid))
					} label: {
						HStack {
							Image(systemName: "magnifyingglass")
								.foregroundStyle(.black)

							Text("Comece sua busca")
								.font(.subheadline)
								.foregroundStyle(.black.opacity(0.6))

							Spacer()
						}
						.padding(.horizontal, 16)
						.padding(.vertical, 18)
						.background(
							RoundedRectangle(cornerRadius: 30)
								.fill(Color.white)
								.shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
						)
					}
					.buttonStyle(.scale)

					Button {
						Manager.Haptic.shared.playHaptic(for: .impact(.rigid))
					} label: {
						Image(systemName: "slider.horizontal.3")
							.foregroundColor(.black)
							.padding(12)
							.background(
								Circle()
									.fill(Color.white)
									.shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
							)
					}
					.buttonStyle(.scale)
				}
				.padding(.horizontal, 16)
				.padding(.top, isExpanded ? 0 : 16)
				.matchedGeometryEffect(id: "home.header.card", in: animation)

				CategoryTabView()

				GeometryReader {
					let size = $0.size

					ScrollView(.horizontal, showsIndicators: false) {
						LazyHStack(spacing: 0) {
							ForEach(controller.tabs, id: \.id) { tab in
								Text(tab.id.rawValue)
									.foregroundStyle(.blue)
									.frame(width: size.width, height: size.height, alignment: .center)
									.contentShape(.rect)
							}
						}
						.scrollTargetLayout()
						.rect { rect in
							let rawProgress = -rect.minX / size.width
							let maxProgress = CGFloat(controller.tabs.count - 1)
							controller.progress = min(max(0, rawProgress), maxProgress)
						}
					}
					.scrollPosition(id: $controller.mainViewScrollState)
					.scrollIndicators(.hidden)
					.scrollTargetBehavior(.paging)
					.onChange(of: controller.mainViewScrollState) { oldValue, newValue in
						if let newValue {
							withAnimation(.snappy) {
								controller.tabBarScrollState = newValue
								controller.activeTab = newValue
							}
						}
					}
				}
				.frame(maxHeight: .infinity)
			}
		}

		@ViewBuilder
		private func CategoryTabView() -> some View {
			GeometryReader {
				let size = $0.size
				ScrollView(.horizontal) {
					HStack(spacing: 20) {
						ForEach($controller.tabs) { $tab in
							Button {
								withAnimation(.snappy) {
									controller.activeTab = tab.id
									controller.tabBarScrollState = tab.id
									controller.mainViewScrollState = tab.id
									Manager.Haptic.shared.playHaptic(for: .impact(.soft))
								}
							} label: {
								Text(tab.id.rawValue)
									.padding(.vertical, 12)
									.padding(.horizontal, 4)
									.foregroundStyle(controller.activeTab == tab.id ? .black : .gray)
									.contentShape(.rect)
									// Usando ScrollTransition para animar os itens durante a rolagem
									.scrollTransition(.interactive) { content, phase in
										content
											.scaleEffect(
												phase.isIdentity ? 1.0 : 0.9
											)
											.opacity(
												phase.isIdentity ? 1.0 : 0.7
											)
									}
							}
							.buttonStyle(.plain)
							.id(tab.id)
							.rect { rect in
								tab.size = rect.size
								tab.minX = rect.minX
							}
						}
					}
					.padding(.horizontal, 15)
					.scrollTargetLayout()
				}
				// Usando scrollPosition com anchor dinâmico
				.scrollPosition(
					id: $controller.tabBarScrollState,
					anchor: .center
				)
				// Usando o novo recurso do iOS 18 para monitorar a geometria de rolagem
				.onScrollGeometryChange(for: CGFloat.self) { geo in
					// Apenas monitorando o offset sem tentar ajustar a posição
					geo.contentOffset.x
				} action: { oldValue, newValue in

				}
				.scrollTargetBehavior(.viewAligned)
				.scrollIndicators(.hidden)
				.scrollClipDisabled(true)
				.overlay(alignment: .bottom) {
					ZStack(alignment: .leading) {
						Rectangle()
							.fill(.gray.opacity(0.3))
							.frame(height: 1)

						let inputRange = controller.tabs.indices.compactMap { return CGFloat($0) }
						let outputRange = controller.tabs.compactMap { return $0.size.width }
						let outputPositionRange = controller.tabs.compactMap { return $0.minX }
						let indicatorWidth = controller.progress.interpolate(inputRange: inputRange, outputRange: outputRange)
						let indicatorPosition = controller.progress.interpolate(inputRange: inputRange, outputRange: outputPositionRange)

						Rectangle()
							.fill(.black)
							.frame(width: indicatorWidth, height: 1.5)
							.offset(x: indicatorPosition)
					}
				}
				.safeAreaPadding(.horizontal, 15)
				.onChange(of: controller.tabBarScrollState) { oldValue, newValue in
					if let newValue {
						withAnimation(.snappy) {
							controller.activeTab = newValue
							controller.mainViewScrollState = newValue

							Manager.Haptic.shared.playHaptic(for: .impact(.soft))
						}
					}
				}
			}
			.frame(height: 60)
		}
	}
}
