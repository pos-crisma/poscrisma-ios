//
//  HomeController.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 11/09/2024.
//

import UIKitNavigation
import XCTestDynamicOverlay
import Dependencies
import CustomDump

extension Home {
    @Observable
    class Controller {
        var isLoading = false
		var showReplay = true

        var onLogout: () -> Void = {
            XCTFail("Login.Controller.onSuccess unimplemented.")
        }
        
        var destination: Destination? {
            didSet { bind() }
        }
        
        @ObservationIgnored
        @Dependency(\.supabaseClient) var client
        
        init(isLoading: Bool = false) {
            self.isLoading = isLoading
        }
        
        @CasePathable
        enum Destination {
            case airbnb(Airbnb.Controller)
            case homeDetail(HomeDetail.Controller)
            case isError(OnError.Controller)
        }
        
        func setLogout() {
            isLoading = true
            Task.detached(priority: .background) { [weak self] in
                guard let self else { return }
                do {
                    dump("Starting to logout")
                    try await client.logout()
                    
                    isLoading = false
                    onLogout()
                } catch {
                    isLoading = false
                    destination = .isError(.init())
                }
            }
        }

		func handleReplay() {
			showReplay = false
		}

        func presentAirbnb() {
            destination = .airbnb(.init())
        }
        
        func closePresentAirbnb() {
            destination = nil
        }
        
        private func bind() {
            switch destination {
            case .airbnb(let controller):
                controller.onClose = {  [weak self] in
                    guard let self else { return }
                    closePresentAirbnb()
                }
                
                break
            case .homeDetail(_):
                
                break
            case .isError(_):
                
                break
            case .none:
                break
            }
        }
    }
}
