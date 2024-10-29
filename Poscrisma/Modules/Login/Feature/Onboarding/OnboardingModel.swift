//
//  OnboardingModel.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 27/10/24.
//

import Foundation

extension Onboarding {
    enum Step {
        case create
        case entry
    }
    
    struct CreateCamping {
        let name: String
        let address: String
        let campingCode: String
    }
}
