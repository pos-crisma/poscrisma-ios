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
                }
                
                if let homeController = controller.homeController {
                    UIViewControllerRepresenting {
                        Home.ViewController(controller: homeController)
                    }
                }
            }
            .onAppear(perform: controller.onInitController)
        }
    }
}


