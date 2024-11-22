//
//  OnboardingCodeCampingController.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 27/10/2024.
//

import UIKit
import UIKitNavigation
import XCTestDynamicOverlay

extension OnboardingCodeCamping {
    
    @Observable
    class Controller: Identifiable {
        
        
        var onSuccessCreate: (_ name: String, _ address: String, _ code: String) -> Void = { _, __, ___ in
            XCTFail("OnboardingCodeCamping.Controller.onSuccessCreate unimplemented.")
        }
        
        var onSuccessInvite: (_ code: String) -> Void = { _ in
            XCTFail("OnboardingCodeCamping.Controller.onSuccessInvite unimplemented.")
        }
        
        var step: Onboarding.Step
        
        var name: String = "" {
            didSet {
                enabledButton()
            }
        }
        var nameIsFocus: Bool = false
        
        var address: String = "" {
            didSet {
                enabledButton()
            }
        }
        var addressIsFocus: Bool = false
        
        var code: String = "" {
            didSet {
                enabledButton()
            }
        }
        var codeIsFocus: Bool = false
        var hasValidation: Bool = false
        
        var destination: Destination? {
            didSet { bind() }
        }
        
        // MARK: - Initialize
        
        init(step: Onboarding.Step) {
            self.step = step
        }
        
        // MARK: - Destination
        
        @CasePathable
        enum Destination {
            case error(OnboardingError.Controller)
            case loading(OnboardingLoading.Controller)
        }
        
        private func enabledButton() {
            if step == .entry {
                if code.isEmpty == false && code.count == 10 {
                    hasValidation = true
                } else {
                    hasValidation = false
                }
            } else {
                if name.isEmpty == false && address.isEmpty == false && code.isEmpty == false && code.count == 10 {
                    hasValidation = true
                } else {
                    hasValidation = false
                }
            }
        }
        
        func goToCreateCamping() {
            destination = nil
            destination = .loading(.init())
            
            Task(priority: .background) {
                do {
                    try await Service.Camping.createCamping(address: address,campingCode: code, name: name)
                    onSuccessCreate(name, address, code)
                } catch let error {
                    dump(error, name: "Error create Camping")
                    await MainActor.run {
                        destination = .error(.init())
                    }
                }
            }
        }
        
        func goToInviteCamping() {
            destination = nil
            onSuccessInvite(code)
        }
        
        
        func initOnboardingFlow() {
            destination = .loading(.init())
            
            if step == .entry {
                goToInviteCamping()
            } else {
                goToCreateCamping()
            }
        }
        
        // MARK: - Binding Destination actions
        
        private func bind() {
            switch destination {
            case .error(_):
                break
            case .loading(_):
                break
            case .none:
                break
            }
        }
    }
}
