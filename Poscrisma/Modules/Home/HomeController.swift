//
//  HomeController.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 11/09/2024.
//

import UIKit

extension Home {
    @Observable
    class Controller {
        var isLogout = false
        
        func setLogout() {
            isLogout = true
        }
    }
}
