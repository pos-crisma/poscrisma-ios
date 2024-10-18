//
//  RootController.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 17/10/2024.
//

import UIKit
import SwiftUI

extension Root {
    
    @Observable
    class Controller {
        var loginController: Login.Controller?
        var homeController: Home.Controller?
        
        func onInitController() {
            homeController = nil
            loginController = .init(isLogged: false)
        }
        
        func handlerSuccessLogin() {
            homeController = .init(isLogout: false)
            loginController = nil
        }
        
        func handlerLogout() {
            homeController = nil
            loginController = .init(isLogged: false)
        }
    }
}
