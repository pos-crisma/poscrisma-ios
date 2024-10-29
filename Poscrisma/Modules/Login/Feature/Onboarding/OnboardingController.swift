//
//  OnboardingController.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 22/10/2024.
//

import UIKit
import XCTestDynamicOverlay
import UIKitNavigation

extension Onboarding {
    
    @Observable
    class Controller: Identifiable {
        let user: Service.User
        
        var destination: Destination? {
            didSet { bind() }
        }
        
        var onSuccess: () -> Void = {
            XCTFail("Onboarding.Controller.onSuccess unimplemented.")
        }
        
        init(user: Service.User) {
            self.user = user
            
            bind()
        }
        
        @CasePathable
        enum Destination {
            case notification(OnboardingNotification.Controller)
            case campCode(OnboardingCodeCamping.Controller)
            case userName(OnboardingUserName.Controller)
            case step(OnboardingStep.Controller)
        }
        
        func goToNotification() {
            destination = .step(.init())
        }
        
        private func bind() {
            switch destination {
            case .notification(let model):
                model.onHandler = { [weak self] in
                    guard let self else { return }
                    destination = .campCode(.init(step: .create))
                }
                break
            case .campCode(_):
                break
            case .userName(_):
                break
            case .step(let model):
                model.onHandlerEntryCamping = { [weak self] in
                    guard let self else { return }
                    destination = .campCode(.init(step: .entry))
                }
                
                model.onHandlerCreateCamping = { [weak self] in
                    guard let self else { return }
                    destination = .campCode(.init(step: .create))
                }
                break
            case .none:
                break
            }
        }
    }
}
