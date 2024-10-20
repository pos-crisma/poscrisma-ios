//
//  HomeController.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 11/09/2024.
//

import UIKit
import SwiftUI
import UIKitNavigation
import XCTestDynamicOverlay
import Dependencies
import CustomDump

extension Home {
    @Observable
    class Controller {
        var isLogout = false
        
        
        var onLogout: () -> Void = {
            XCTFail("Login.Controller.onSuccess unimplemented.")
        }
        
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
            case airbnb(Airbnb.Controller)
            case homeDetail(HomeDetail.Controller)
        }
        
        init(isLogout: Bool = false) {
            self.isLogout = isLogout
        }
        
        func setLogout() {
            Task {
                do {
                    try await client.logout()
                    onLogout()
                } catch {
                    dump(error)
                }
            }
            
            
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
            case .homeDetail(let controller):
                
                break
            case .none:
                break
            }
        }
    }
}
