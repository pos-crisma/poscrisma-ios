//
//  HomeController.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 11/09/2024.
//

import UIKit
import SwiftUI

extension Home {
    @Observable
    class Controller {
        var isLogout = false
        
        init(isLogout: Bool = false) {
            self.isLogout = isLogout
        }
        
        func setLogout() {
            isLogout = true
        }
    }
}
