//
//  LoginView.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 15/10/2024.
//

import SwiftUI
import UIKitNavigation

extension Login {
    
    @MainActor
    struct ViewController: View {
        @State var controller: Controller
        
        @State private var currentDetent = PresentationDetent.large

        var body: some View {
            ZStack(alignment: .bottom) {

                BackgroundView(tiles: controller.tiles) {
                    controller.goToCampaign(with: $0)
                }
                
                ForegroundView(isLoading: controller.isLoading, 
                               handlerGoogle: controller.startGoogleAuthentication,
                               handlerApple: controller.startAppleAuth)
            }
            .sheet(item: $controller.destination.camping) {
                Camping.ViewController(model: $0)
            }
            .sheet(item: $controller.destination.isLoading) { model in
                UIViewControllerRepresenting {
                    LoginLoading.ViewController(model: model)
                }
            }
            .sheet(item: $controller.destination.isError) { model in
                UIViewControllerRepresenting {
                    LoginError.ViewController(model: model)
                }
                .presentationDetents([.medium])   
            }
        }
    }
}

#Preview {
    Login.ViewController(controller: .init())
}
