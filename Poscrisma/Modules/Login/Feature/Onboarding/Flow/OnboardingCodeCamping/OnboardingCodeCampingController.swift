//
//  OnboardingCodeCampingController.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 27/10/2024.
//

import UIKit
import UIKitNavigation

extension OnboardingCodeCamping {
    
    @Observable
    class Controller: Identifiable {
        
        var step: Onboarding.Step
        
        var name: String = ""
        var nameIsFocus: Bool = false
        
        var address: String = ""
        var addressIsFocus: Bool = false
        
        var code: String = ""
        var codeIsFocus: Bool = false
        
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
