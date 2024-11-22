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
        @ObservationIgnored
        @Dependency(\.network) var network
        
        init(isLoading: Bool = false, isLogged: Bool = false, destination: Destination? = nil) {
            self.isLoading = isLoading
            self.isLogged = isLogged
            self.destination = destination
            
            bind()
        }
        
        @CasePathable
        enum Destination {
            case onboarding(Onboarding.Controller)
            case camping(Camping.Controller)
            case isLoading(LoginLoading.Controller)
            case isError(LoginError.Controller)
        }
        
        // MARK: - User Actions
        
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
                        let campings = try await Service.MemberCamping.getUserHasCamping()
                        campingsDestination(with: campings)

                    } catch {
                        await MainActor.run { [weak self] in
                            guard let self else { return }
                            goToErrorView(with: .appleSupabase)
                        }
                    }
                    break
                case .failure(let error):
                    
                    try await client.logout()
                    
                    if let error = error as? Manager.Network.NetworkError {
                        goToErrorView(with: .endpoint(error))
                        return
                    }
                    
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
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    goToLoadingView()
                }
                
                do {
                    let _ = try await client.signInGoogle(idToken, accessToken)
                    
                    let campings = try await Service.MemberCamping.getUserHasCamping()
                    campingsDestination(with: campings)

                } catch let error {
                    
                    try await client.logout()
                    
                    if let error = error as? Manager.Network.NetworkError {
                        goToErrorView(with: .endpoint(error))
                        return
                    }
                    
                    goToErrorView(with: .googleSupabase)
                }
            }
        }
        
        // MARK: - Destination
        
        private func campingsDestination(with value: Service.MemberCampingResponse) {
            if value.campings.isEmpty {
                goToOnboarding()
            } else {
                onSuccess()
            }
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
        
        private func goToOnboarding() {
            destination = .onboarding(.init())
        }
        
        // MARK: - Binding Destination actions
        
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
            case .onboarding(let model):
                model.onSuccess = {[weak self] in
                    guard let self else { return }
                    onSuccess()
                }
                break
            case .none:
                break
            }
        }
    }
}
