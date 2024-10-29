//
//  OnboardingView.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 27/10/24.
//

import SwiftUI
import SwiftNavigation
import UIKitNavigation

extension Onboarding {
    
    @MainActor
    struct ViewController: View {
        @State var controller: Controller
        
        var body: some View {
            NavigationStack {
                UIViewControllerRepresenting {
                    OnboardingInitial.ViewController {
                        controller.goToNotification()
                    }
                }
                .fullScreenCover(item: $controller.destination.campCode) { value in
                    UIViewControllerRepresenting {
                        OnboardingCodeCamping.ViewController(model: value)
                    }
                }
                .fullScreenCover(item: $controller.destination.notification) { value in
                    UIViewControllerRepresenting {
                        OnboardingNotification.ViewController(model: value)
                    }
                }
                .fullScreenCover(item: $controller.destination.userName) { value in
                    UIViewControllerRepresenting {
                        OnboardingUserName.ViewController(model: value)
                    }
                }
                .fullScreenCover(item: $controller.destination.step) { value in
                    UIViewControllerRepresenting {
                        OnboardingStep.ViewController(model: value)
                    }
                }
            }
            .preferredColorScheme(.light)
        }
    }
}
