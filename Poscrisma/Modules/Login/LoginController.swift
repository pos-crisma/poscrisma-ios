//
//  LoginController.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 15/10/2024.
//

import SwiftUI
import SwiftUINavigation
import XCTestDynamicOverlay
import AuthenticationServices
import Dependencies

extension Login {
    
    @Observable
    class Controller: Identifiable {
        var isLoading = false
        var isLogged = false
        var destination: Destination?
        let tiles: [Int: TileData] = tileDataMock
        
        var onSuccess: () -> Void = {
            XCTFail("Login.Controller.onSuccess unimplemented.")
        }
        
        @ObservationIgnored
        @Dependency(\.supabaseClient) var client
        
        init(isLoading: Bool = false, isLogged: Bool = false, destination: Destination? = nil) {
            self.isLoading = isLoading
            self.isLogged = isLogged
            self.destination = destination
        }
        
        @CasePathable
        enum Destination {
            case camping(Camping.Controller)
            case isLoading(LoginLoading.Controller)
            case isError(LoginError.Controller)
        }
        
        func goToFeatureModal(with index: Int) {
            guard let tiles = tiles[index] else { return }
            let model = Camping.Controller(tile: tiles)
            
            destination = .camping(model)
        }
        
        
        private func goToLoadingView() {
            destination = nil
            destination = .isLoading(.init())
        }
        
        
        private func goToErrorView() {
            destination = nil
            destination = .isError(.init())
        }
        
        func startAppleAuth(result: Result<ASAuthorization, Error>) {
            
            Manager.Haptic.shared.playHaptic(for: .impact(.medium))
            Task {
                switch result {
                case .success(let result):
                    
                    goToLoadingView()
                    
                    do {
                        guard let credential = result.credential as? ASAuthorizationAppleIDCredential else { return }
                        guard let idToken = credential.identityToken.flatMap({ String(data: $0, encoding: .utf8) }) else { return }
                        
                        let session = try await client.signInApple(idToken)
                        
                        // TODO: Move session to memory for reuse on endpoints
                        // TODO: in loading scenary call profile endpoint for validate state in application ( if not has profile go to onboarding ).
                        
                        onSuccess()
                    } catch {
                        dump(error)
                        goToErrorView()
                    }
                    break
                case .failure(let error):
                    dump(error)
                    goToErrorView()
                    break
                }
            }
        }
        
        func startGoogleAuthentication() {
            onSuccess()
        }
    }
}
