//
//  LoginView.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 15/10/2024.
//

import SwiftUI
import UIKitNavigation

extension Login {
    struct ViewController: View {
        @State var controller: Controller

        var body: some View {
            ZStack(alignment: .bottom) {

                BackgroundView(tiles: controller.tiles) {
                    controller.goToFeatureModal(with: $0)
                }
                
                ForegroundView(isLoading: controller.isLoading, handlerGoogle: controller.startGoogleAuthentication, handlerApple: controller.startAppleAuth(result:))
            }
            .sheet(item: $controller.destination.camping) { model in
                Camping.ViewController(model: model)
            }
            .fullScreenCover(item: $controller.destination.isLoading) { model in
                UIViewControllerRepresenting {
                    LoginLoading.ViewController(model: model)
                }
            }
            .sheet(item: $controller.destination.isError) { model in
                UIViewControllerRepresenting {
                    LoginError.ViewController(model: model)
                }
            }
        }
    }
}

#Preview {
    Login.ViewController(controller: .init())
}
