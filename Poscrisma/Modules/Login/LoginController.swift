//
//  LoginController.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 15/10/2024.
//

import UIKit
import SwiftUINavigation

extension Login {
    
    @Observable
    class Controller {
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
            
        }
    }
}
