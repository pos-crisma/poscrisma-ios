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
        
        init(isLoading: Bool = false, isLogged: Bool = false, destination: Destination? = nil) {
            self.isLoading = isLoading
            self.isLogged = isLogged
            self.destination = destination
        }
        
        @CasePathable
        enum Destination {
            case showFeature(TileData)
        }
        
        func goToFeatureModal(with index: Int) {
            guard let tiles = tiles[index] else { return }
            destination = .showFeature(tiles)
        }
        
        
        func startGoogleAuthentication() {
            isLogged = true
        }
    }
}
