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
            withAnimation {
                homeController = nil
                loginController = .init()
            }
        }
        
        func handlerSuccessLogin() {
            withAnimation {
                homeController = .init()
                loginController = nil
            }
        }
        
        func handlerLogout() {
            withAnimation {
                homeController = nil
                loginController = .init()
            }
        }
    }
}
