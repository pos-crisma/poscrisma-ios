//
//  AirbnbController.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 08/09/2024.
//

import UIKit
import XCTestDynamicOverlay

extension Airbnb {
    @Observable
    class Controller: Identifiable { 
        var onClose: () -> Void = {
            XCTFail("Login.Controller.onSuccess unimplemented.")
        }
    }
}
