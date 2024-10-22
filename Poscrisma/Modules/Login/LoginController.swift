//
//  LoginController.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 15/10/2024.
//

import UIKit
import SwiftUI
import SwiftUINavigation
import XCTestDynamicOverlay
import AuthenticationServices
import Dependencies
import CustomDump

import GoogleSignIn

extension Login {
    
    @Observable
    class Controller: Identifiable {
        var isLoading = false
        var isLogged = false
        let tiles: [Int: TileData] = tileDataMock
        
        var destination: Destination? {
            didSet { bind() }
        }
        
        var onSuccess: () -> Void = {
            XCTFail("Login.Controller.onSuccess unimplemented.")
        }
        
        @ObservationIgnored
        @Dependency(\.supabaseClient) var client
        
        init(isLoading: Bool = false, isLogged: Bool = false, destination: Destination? = nil) {
            self.isLoading = isLoading
            self.isLogged = isLogged
            self.destination = destination
            
            bind()
        }
        
        @CasePathable
        enum Destination {
            case camping(Camping.Controller)
            case isLoading(LoginLoading.Controller)
            case isError(LoginError.Controller)
        }
        
        func goToCampaign(with index: Int) {
            guard let tiles = tiles[index] else { return }
            let model = Camping.Controller(tile: tiles)
            
            destination = .camping(model)
        }
        
        private func goToLoadingView() {
            destination = .isLoading(.init())
        }
        
        private func goToErrorView(with error: LoginError.Controller.State) {
            destination = .isError(.init(errorType: error))
        }
        
        func startAppleAuth(_ result: Result<ASAuthorization, Error>) {
            
            Manager.Haptic.shared.playHaptic(for: .impact(.medium))
            
            Task.detached(priority: .background) { [weak self] in
                guard let self else { return }
                
                switch result {
                case .success(let result):
                    await MainActor.run { [weak self] in
                        guard let self else { return }
                        goToLoadingView()
                    }
                    
                    do {
                        guard let credential = result.credential as? ASAuthorizationAppleIDCredential else { return }
                        guard let idToken = credential.identityToken.flatMap({ String(data: $0, encoding: .utf8) }) else { return }
                        
                        let _ = try await client.signInApple(idToken)
                        
                        // TODO: Move session to memory for reuse on endpoints
                        // TODO: in loading scenary call profile endpoint for validate state in application ( if not has profile go to onboarding ).
                        
                        await MainActor.run { [weak self] in
                            guard let self else { return }
                            onSuccess()
                        }
                    } catch {
                        await MainActor.run { [weak self] in
                            guard let self else { return }
                            goToErrorView(with: .appleSupabase)
                        }
                    }
                    break
                case .failure(let error):
                    guard let error = error as? ASAuthorizationError else {
                        goToErrorView(with: .unknown)
                        return
                    }
                    
                    switch error.code {
                    case .canceled: break
                    case .failed, .invalidResponse, .notHandled, .notInteractive:
                        goToErrorView(with: .appleError)
                        break
                    default:
                        goToErrorView(with: .appleUnknown)
                        break
                    }
                }
            }
        }
        
        func startGoogleAuthentication(_ idToken: String, _ accessToken: String) {
            
            Task.detached(priority: .background) { [weak self] in
                guard let self else { return }
                
                do {
                    await MainActor.run { [weak self] in
                        guard let self else { return }
                        goToLoadingView()
                    }
                    
                    let _ = try await client.signInGoogle(idToken, accessToken)
                    
                    // TODO: Move session to memory for reuse on endpoints
                    // TODO: in loading scenary call profile endpoint for validate state in application ( if not has profile go to onboarding ).
                    
                    await MainActor.run { [weak self] in
                        guard let self else { return }
                        onSuccess()
                    }
                } catch let err {
                    
                    dump("What is error: \(err)")
                    goToErrorView(with: .googleSupabase)
                }
            }
        }
        
        private func bind() {
            switch destination {
            case .camping(_):
                break
            case .isError(let model):
                model.onHandler = {[weak self] in
                    guard let self else { return }
                    destination = nil
                }
                break
            case .isLoading(_):
                break
            case .none:
                break
            }
        }
    }
}
