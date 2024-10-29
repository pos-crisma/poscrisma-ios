//
//  OnboardingStepController.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 27/10/2024.
//

import UIKit
import XCTestDynamicOverlay

extension OnboardingStep {
    
    @Observable
    class Controller: Identifiable { 
        var onHandlerCreateCamping: () -> Void = {
            XCTFail("OnboardingStep.onHandlerCreateCamping unimplemented.")
        }
        var onHandlerEntryCamping: () -> Void = {
            XCTFail("OnboardingStep.onHandlerEntryCamping unimplemented.")
        }
    }
}
