//
//  OnboardingNotificationController.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 27/10/2024.
//

import UIKit
import XCTestDynamicOverlay

extension OnboardingNotification {
    
    @Observable
    class Controller: Identifiable {
        var onHandler: () -> Void = {
            XCTFail("OnboardingInitial.onHandler unimplemented.")
        }
        
        
    }
}
