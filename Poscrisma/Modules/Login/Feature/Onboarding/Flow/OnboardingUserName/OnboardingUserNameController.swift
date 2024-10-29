//
//  OnboardingUserNameController.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 27/10/2024.
//

import UIKit
import UIKitNavigation

extension OnboardingUserName {
    
    @Observable
    class Controller: Identifiable { 
        
        var destination: Destination? {
            didSet { bind() }
        }
        
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
