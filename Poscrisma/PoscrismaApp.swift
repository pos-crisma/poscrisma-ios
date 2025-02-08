//
//  PoscrismaApp.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 07/09/24.
//

import SwiftUI
import GoogleSignIn

@main
struct PoscrismaApp: App {
    @UIApplicationDelegateAdaptor(CoreApp.Delegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
			RootView {
				ApplePhoto.ContentView()
//				Root.ViewController(controller: .init())
//					.onOpenURL { url in
//						GIDSignIn.sharedInstance.handle(url)
//					}
//					.ignoresSafeArea()
			}
        }
    }
}
