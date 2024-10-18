//
//  LoginController.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 15/10/2024.
//

import SwiftUI
import SwiftUINavigation

extension Login {
    
    @Observable
    class Controller {
        var isLoading = false
        var isLogged = false
        var destination: Destination?
        let tiles: [Int: TileData] = tileDataMock
        
        @CasePathable
        enum Destination {
            case showFeature(TileData)
        }
        
        func goToFeatureModal(with index: Int) {
            guard let tiles = tiles[index] else { return }
            destination = .showFeature(tiles)
        }
        
        
        func startGoogleAuthentication() {
            withAnimation {
                isLoading = true
                Task { @MainActor in
                    try? await Task.sleep(for: .seconds(1))
                    isLogged = true
                    isLoading = false
                }
            }
        }
    }
}
