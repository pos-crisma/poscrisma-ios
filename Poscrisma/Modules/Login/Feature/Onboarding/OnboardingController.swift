//
//  OnboardingController.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 22/10/2024.
//

import UIKit
import XCTestDynamicOverlay

extension Onboarding {
    
    @Observable
    class Controller: Identifiable {
        let user: Login.User
        
        var onSuccess: () -> Void = {
            XCTFail("Onboarding.Controller.onSuccess unimplemented.")
        }
        
        init(user: Login.User) {
            self.user = user
        }
    }
}
