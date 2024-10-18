//
//  LoginView.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 15/10/2024.
//

import SwiftUI
import SpriteKit

extension Login {
    struct ViewController: View {
        @State var controller: Controller

        var body: some View {
            ZStack(alignment: .bottom) {

                BackgroundView(tiles: controller.tiles) {
                    controller.goToFeatureModal(with: $0)
                }
                
                ForegroundView {
                    controller.startGoogleAuthentication()
                }
                .padding(.bottom)
            }
            .sheet(item: $controller.destination.showFeature) { $item in
                
                Form {
                    Text("\($item.wrappedValue.title)")
                }
                .navigationTitle("Sheet with payload")
            }
        }
    }
}





#Preview {
    Login.ViewController(controller: .init())
}




