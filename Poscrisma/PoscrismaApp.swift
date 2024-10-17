//
//  PoscrismaApp.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 07/09/24.
//

import SwiftUI
import UIKitNavigation

@main
struct PoscrismaApp: App {
    @UIApplicationDelegateAdaptor(CoreApp.Delegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            BackgroundView()
            .ignoresSafeArea()
        }
    }
}
