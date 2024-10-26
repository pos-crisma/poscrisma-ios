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
        let user: AppModel.User
        
        var text: String = "" {
            didSet {
                dump(text, name: "Text")
            }
        }
        var isFocus: Bool = false
        
        var onSuccess: () -> Void = {
            XCTFail("Onboarding.Controller.onSuccess unimplemented.")
        }
        
        init(user: AppModel.User) {
            self.user = user
        }
    }
}
