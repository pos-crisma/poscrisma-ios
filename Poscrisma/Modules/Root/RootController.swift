//
//  RootController.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 17/10/2024.
//

import SwiftUI
import UIKitNavigation
import Dependencies
import CustomDump

extension Root {
    
    @Observable
    class Controller {
        
        var destination: Destination? {
            didSet { bind() }
        }
        
        
        @ObservationIgnored
        @Dependency(\.supabaseClient) var client
        
        init() {
            bind()
        }
        
        @CasePathable
        enum Destination {
            case login(Login.Controller)
            case home(Home.Controller)
        }
        
        private func goToHome() {
            withAnimation {
                destination = .home(.init())
            }
        }
        
        private func goToLogin() {
            withAnimation {
                destination = .login(.init())
            }
        }
        
        func verifyUserIsLogged() {
            Task {
                do {
                    guard let _ = try await client.getUser() else {
                        goToLogin()
                        return
                    }
                    
                    goToHome()
                    
                } catch {
                    customDump(error)
                    
                }
            }
        }
        
        private func bind() {
            switch destination {
            case .login(let controller):
                controller.onSuccess = { [weak self] in
                    guard let self else { return }
                    verifyUserIsLogged()
                }
                
                break
            case .home(let controller):
                controller.onLogout = { [weak self] in
                    guard let self else { return }
                    verifyUserIsLogged()
                }
                
                break
            case .none:
                break
            }
        }
    }
}
