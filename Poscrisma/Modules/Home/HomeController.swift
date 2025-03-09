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
import SwiftUI

extension Home {
    @Observable
    class Controller {
        var isLoading = false
		var showReplay = true

        var tabs: [CategoryTab] = [
			.init(id: CategoryTab.Tab.research),
            .init(id: CategoryTab.Tab.development), 
            .init(id: CategoryTab.Tab.analytics),
            .init(id: CategoryTab.Tab.audience),
            .init(id: CategoryTab.Tab.content),
            .init(id: CategoryTab.Tab.settings),
            .init(id: CategoryTab.Tab.help)
        ]
		var activeTab: CategoryTab.Tab = .research
		var tabBarScrollState: CategoryTab.Tab?
		var mainViewScrollState: CategoryTab.Tab?

		var progress: CGFloat = .zero


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
