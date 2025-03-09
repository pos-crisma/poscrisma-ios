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
            
            Group {
                switch self.controller.destination {
                case .login(let model):
                    Login.ViewController(controller: model)
                case .home(let model):
                    NavigationStack {
                        Home.ViewController(controller: model)
                    }
                case .none:
                    Rectangle()
                }
            }
            .onAppear(perform: controller.verifyUserIsLogged)
        }
    }
}


