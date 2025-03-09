//
//  HomeView.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 11/09/2024.
//

import SwiftUI
import UIKitNavigation

extension Home {
    struct ViewController: View {
        @State var controller: Controller
        
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
            VStack(spacing: 16) {
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
                
                // Categorias
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 24) {
                        CategoryItem(icon: "house.fill", title: "Casas pequenas", isSelected: true)
                        CategoryItem(icon: "ticket", title: "Ingressos")
                        CategoryItem(icon: "water.waves", title: "Beira do lago")
                        CategoryItem(icon: "house", title: "Casas na árvore")
                        CategoryItem(icon: "building.2", title: "Cidades")
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                }
                
                Spacer()
            }
        }
        
        @ViewBuilder
        private func CategoryItem(icon: String, title: String, isSelected: Bool = false) -> some View {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .black : .gray)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(isSelected ? .black : .gray)
            }
            .frame(height: 70)
            .overlay(alignment: .bottom) {
                if isSelected {
                    Rectangle()
                        .frame(height: 2)
						.frame(maxWidth: .infinity)
                        .foregroundColor(.black)
                }
            }
        }
    }
}

#Preview {
    Home.ViewController(controller: .init())
}
