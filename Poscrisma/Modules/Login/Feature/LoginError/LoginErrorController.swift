//
//  LoginErrorController.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 20/10/2024.
//

import UIKit
import XCTestDynamicOverlay

extension LoginError {
    @Observable
    class Controller: Identifiable {
        var onHandler: () -> Void = {
            XCTFail("LoginError.Controller.onHandler unimplemented.")
        }
        
        enum State {
            // Apple
            case appleCancel
            case appleError
            case appleUnknown
            case appleSupabase
            // Google
            case googleCancel
            case googleError
            case googleUnknown
            case googleSupabase
            // Endpoint
            case endpoint(Manager.Network.NetworkError)
            // Unknown
            case unknown
        }
        
        let errorType: State
        
        init(errorType: State) {
            self.errorType = errorType
        }
    }
}
