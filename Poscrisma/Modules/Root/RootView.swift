//
//  RootView.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 17/10/2024.
//

import Epoxy
import SwiftUI
import UIKitNavigation

extension Root {
    struct ViewController: View {
        
        @State var controller: Controller
        
        var body: some View {
            
            ZStack {
                if let loginController = controller.loginController {
                    Login.ViewController(controller: loginController)
                        .onChange(of: loginController.isLogged) { _, newValue in
                            if newValue { controller.handlerSuccessLogin() }
                        }
                        .ignoresSafeArea(.container)
                        .transition(.opacity.combined(with: .move(edge: .leading)))
                        .animation(.easeInOut(duration: 0.3), value: controller.loginController != nil)
                }
                
                if let homeController = controller.homeController {
                    NavigationStack {
                        UIViewControllerRepresenting {
                            Home.ViewController(controller: homeController)
                        }
                        .ignoresSafeArea(.container)
                        .onChange(of: homeController.isLogout) { _, newValue in
                            if newValue { controller.handlerLogout() }
                        }
                        .transition(.opacity.combined(with: .move(edge: .trailing)))
                        .animation(.easeInOut(duration: 0.3), value: controller.homeController != nil)

                    }
                }
            }
            .onAppear(perform: controller.onInitController)
            
        }
    }
}


